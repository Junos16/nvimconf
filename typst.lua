-- typst.lua
--
-- Small Typst live-preview helper for Neovim.
--
-- Architecture:
--
--   normal Tinymist
--       -> completion / diagnostics / hover / etc.
--
--   temporary preview Tinymist
--       -> exportPdf = "onType"
--       -> writes PDF into /tmp
--       -> Zathura displays that PDF
--
-- No source autosaving is involved. Unsaved buffer changes are sent
-- directly to the preview Tinymist through LSP.

local M = {}

-- ---------------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------------
--
-- Everything here is indexed by Neovim buffer number.
--
-- For example:
--
--   state.previews[12] = 4
--
-- means:
--
--   buffer 12 is being previewed by LSP client 4.

local state = {
	-- bufnr -> temporary Tinymist client id
	previews = {},

	-- bufnr -> temporary directory containing preview.pdf
	tempdirs = {},

	-- bufnr -> Zathura job id
	viewers = {},

	-- bufnr -> true while waiting for the first PDF to appear
	waiting_for_pdf = {},
}

-- ---------------------------------------------------------------------------
-- Small helpers
-- ---------------------------------------------------------------------------

local function current_buf()
	return vim.api.nvim_get_current_buf()
end

local function is_typst_buffer(bufnr)
	return vim.bo[bufnr].filetype == "typst"
end

-- Return the temporary preview Tinymist client for this buffer.
--
-- If the stored client disappeared/crashed/stopped, clear stale state.
local function get_preview_client(bufnr)
	local client_id = state.previews[bufnr]

	if not client_id then
		return nil
	end

	local client = vim.lsp.get_client_by_id(client_id)

	if not client or client:is_stopped() then
		state.previews[bufnr] = nil
		return nil
	end

	return client
end

-- Create one temporary directory per Typst buffer.
--
-- We deliberately reuse it if preview is stopped and restarted.
local function get_tempdir(bufnr)
	local tempdir = state.tempdirs[bufnr]

	if tempdir and vim.fn.isdirectory(tempdir) == 1 then
		return tempdir
	end

	tempdir = vim.fn.tempname()

	vim.fn.mkdir(tempdir, "p")

	if vim.fn.isdirectory(tempdir) ~= 1 then
		return nil
	end

	state.tempdirs[bufnr] = tempdir

	return tempdir
end

-- Tinymist wants outputPath without the final ".pdf".
--
-- For example:
--
--   stem = /tmp/nvim.../preview
--   pdf  = /tmp/nvim.../preview.pdf
local function get_preview_paths(bufnr)
	local tempdir = get_tempdir(bufnr)

	if not tempdir then
		return nil, nil
	end

	local stem = tempdir .. "/preview"
	local pdf = stem .. ".pdf"

	return stem, pdf
end

-- ---------------------------------------------------------------------------
-- Zathura handling
-- ---------------------------------------------------------------------------

local function viewer_is_running(bufnr)
	local job_id = state.viewers[bufnr]

	if not job_id then
		return false
	end

	-- jobwait(..., 0) checks without actually waiting.
	--
	-- -1 means the process is still running.
	local result = vim.fn.jobwait({ job_id }, 0)[1]

	if result == -1 then
		return true
	end

	state.viewers[bufnr] = nil
	return false
end

local function close_viewer(bufnr)
	local job_id = state.viewers[bufnr]

	if job_id and viewer_is_running(bufnr) then
		vim.fn.jobstop(job_id)
	end

	state.viewers[bufnr] = nil
end

-- Tinymist may need a short moment to produce the first PDF.
--
-- This function waits until preview.pdf exists and then launches Zathura.
--
-- It is also useful if the document initially has a Typst error:
-- we keep waiting, and once you fix the source and Tinymist successfully
-- exports it, Zathura opens automatically.
local function open_viewer_when_ready(bufnr, pdf)
	if viewer_is_running(bufnr) then
		return
	end

	-- Avoid creating multiple polling loops.
	if state.waiting_for_pdf[bufnr] then
		return
	end

	state.waiting_for_pdf[bufnr] = true

	local function check()
		-- Preview was stopped while we were waiting.
		if not get_preview_client(bufnr) then
			state.waiting_for_pdf[bufnr] = nil
			return
		end

		if vim.fn.filereadable(pdf) == 1 then
			state.waiting_for_pdf[bufnr] = nil

			local job_id = vim.fn.jobstart({ "zathura", pdf }, {
				detach = true,

				on_exit = function(exited_job_id)
					if state.viewers[bufnr] == exited_job_id then
						state.viewers[bufnr] = nil
					end
				end,
			})

			if job_id <= 0 then
				vim.notify("Could not start Zathura", vim.log.levels.ERROR)
				return
			end

			state.viewers[bufnr] = job_id
			return
		end

		-- Try again after 100 ms.
		vim.defer_fn(check, 100)
	end

	check()
end

-- ---------------------------------------------------------------------------
-- Stopping / cleanup
-- ---------------------------------------------------------------------------

local function stop_preview_client(bufnr)
	local client = get_preview_client(bufnr)

	state.waiting_for_pdf[bufnr] = nil

	if not client then
		state.previews[bufnr] = nil
		return false
	end

	-- Clear our state first.
	--
	-- This prevents the asynchronous on_exit callback from accidentally
	-- touching a new preview client if one is started immediately afterward.
	state.previews[bufnr] = nil

	client:stop()

	return true
end

local function delete_tempdir(bufnr)
	local tempdir = state.tempdirs[bufnr]

	if not tempdir then
		return
	end

	vim.fn.delete(tempdir, "rf")
	state.tempdirs[bufnr] = nil
end

-- Full cleanup:
--
--   stop preview Tinymist
--   close Zathura
--   remove temporary PDF directory
local function cleanup(bufnr)
	stop_preview_client(bufnr)
	close_viewer(bufnr)
	delete_tempdir(bufnr)
end

-- ---------------------------------------------------------------------------
-- Start live preview
-- ---------------------------------------------------------------------------

function M.start(bufnr)
	bufnr = bufnr or current_buf()

	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	if not is_typst_buffer(bufnr) then
		vim.notify("Current buffer is not a Typst file", vim.log.levels.ERROR)
		return
	end

	local source = vim.api.nvim_buf_get_name(bufnr)

	if source == "" then
		vim.notify("Give the Typst buffer a filename before previewing", vim.log.levels.ERROR)
		return
	end

	local existing = get_preview_client(bufnr)

	if existing then
		local _, pdf = get_preview_paths(bufnr)

		if pdf then
			open_viewer_when_ready(bufnr, pdf)
		end

		vim.notify("Typst live preview is already running")
		return
	end

	-- Find your ordinary Mason-managed Tinymist.
	--
	-- We use it as the reference configuration so that the preview client
	-- inherits your real Tinymist project/root/settings instead of imposing
	-- our own projectResolution policy.
	local normal_client = vim.lsp.get_clients({
		name = "tinymist",
		bufnr = bufnr,
	})[1]

	if not normal_client then
		vim.notify("No normal Tinymist client is attached. Check :checkhealth vim.lsp", vim.log.levels.ERROR)
		return
	end

	local output_stem, pdf = get_preview_paths(bufnr)

	if not output_stem then
		vim.notify("Could not create temporary Typst preview directory", vim.log.levels.ERROR)
		return
	end

	-- Copy your ordinary Tinymist settings.
	--
	-- vim.deepcopy is important here:
	--
	--     local settings = normal_client.config.settings
	--
	-- would give us another reference to the SAME Lua table. Changing it
	-- could therefore modify the normal Tinymist configuration.
	--
	-- deepcopy gives us an independent table.
	local settings = vim.deepcopy(normal_client.config.settings or {})

	-- These changes apply ONLY to the temporary preview client.
	settings.exportPdf = "onType"
	settings.outputPath = output_stem

	-- Preserve any LSP flags your normal Tinymist has, then override the
	-- preview-specific ones.
	local flags = vim.tbl_deep_extend("force", vim.deepcopy(normal_client.config.flags or {}), {
		-- Neovim normally waits 150 ms before sending didChange.
		-- 25 ms gives the preview a much more immediate feel.
		debounce_text_changes = 25,

		-- Let Neovim send incremental text edits rather than the whole
		-- document every time, when supported.
		allow_incremental_sync = true,
	})

	-- -----------------------------------------------------------------------
	-- Start a SECOND Tinymist LSP client.
	-- -----------------------------------------------------------------------

	local client_id = vim.lsp.start({
		-- Unique name means Neovim treats this separately from your
		-- ordinary "tinymist" client.
		name = "tinymist-preview-" .. bufnr,

		-- Use the exact Tinymist command selected by your normal LSP.
		cmd = normal_client.config.cmd or { "tinymist" },

		-- Inherit its project root.
		root_dir = normal_client.config.root_dir,

		cmd_cwd = normal_client.config.cmd_cwd,
		cmd_env = normal_client.config.cmd_env,

		init_options = normal_client.config.init_options and vim.deepcopy(normal_client.config.init_options) or nil,

		capabilities = normal_client.config.capabilities and vim.deepcopy(normal_client.config.capabilities) or nil,

		offset_encoding = normal_client.config.offset_encoding,

		settings = settings,
		flags = flags,

		-- We already receive diagnostics from your ordinary Tinymist.
		-- Ignore duplicate diagnostics from the preview client.
		handlers = {
			["textDocument/publishDiagnostics"] = function() end,
		},

		-- The server still advertises completion, hover, formatting,
		-- references, etc.
		--
		-- We do not want TWO Tinymists responding to those requests.
		--
		-- Keep executeCommandProvider intact because we use
		-- tinymist.exportPdf below.
		on_init = function(client)
			local caps = client.server_capabilities

			caps.completionProvider = nil
			caps.hoverProvider = false
			caps.signatureHelpProvider = nil

			caps.definitionProvider = false
			caps.declarationProvider = false
			caps.typeDefinitionProvider = false
			caps.implementationProvider = false
			caps.referencesProvider = false

			caps.documentHighlightProvider = false
			caps.documentSymbolProvider = false
			caps.workspaceSymbolProvider = false

			caps.codeActionProvider = false
			caps.codeLensProvider = nil

			caps.documentFormattingProvider = false
			caps.documentRangeFormattingProvider = false
			caps.documentOnTypeFormattingProvider = nil

			caps.renameProvider = false
			caps.foldingRangeProvider = false
			caps.selectionRangeProvider = false

			caps.semanticTokensProvider = nil
			caps.inlayHintProvider = nil
			caps.documentLinkProvider = nil
		end,

		on_attach = function(client, attached_bufnr)
			if attached_bufnr ~= bufnr then
				return
			end

			-- Schedule this so state.previews[bufnr] has definitely been
			-- populated after vim.lsp.start() returns.
			vim.schedule(function()
				if get_preview_client(bufnr) then
					open_viewer_when_ready(bufnr, pdf)
				end
			end)

			-- onType handles all future exports.
			--
			-- This one explicit export just creates the INITIAL PDF
			-- immediately, before you've typed another character.
			client:exec_cmd({
				title = "Initial Typst PDF export",
				command = "tinymist.exportPdf",
				arguments = { source },
			}, {
				bufnr = bufnr,
			}, function(err)
				if not err then
					return
				end

				-- Don't kill the preview. If the document currently
				-- has an error, onType may succeed as soon as you fix it.
				vim.schedule(function()
					if get_preview_client(bufnr) then
						vim.notify("Initial Typst export failed: " .. tostring(err.message), vim.log.levels.WARN)
					end
				end)
			end)
		end,

		on_exit = function(_, _, exited_client_id)
			-- Only clear state if this is still the client we believe
			-- belongs to the buffer.
			if state.previews[bufnr] == exited_client_id then
				state.previews[bufnr] = nil
			end

			state.waiting_for_pdf[bufnr] = nil
		end,
	}, {
		bufnr = bufnr,

		-- Never let Neovim reuse some existing LSP client here.
		-- This one exists specifically as our private live compiler.
		reuse_client = function()
			return false
		end,
	})

	if not client_id then
		vim.notify("Failed to start Typst preview Tinymist", vim.log.levels.ERROR)
		return
	end

	state.previews[bufnr] = client_id

	vim.notify("Typst live preview started")
end

-- ---------------------------------------------------------------------------
-- Public actions
-- ---------------------------------------------------------------------------

-- Stop live exporting but deliberately leave Zathura open.
--
-- The temporary PDF also remains available while this buffer exists.
function M.stop(bufnr)
	bufnr = bufnr or current_buf()

	if not stop_preview_client(bufnr) then
		vim.notify("No Typst live preview is running")
		return
	end

	vim.notify("Typst live preview stopped")
end

-- Toggle only the live compiler.
--
-- Stopping does NOT close Zathura.
function M.toggle(bufnr)
	bufnr = bufnr or current_buf()

	if get_preview_client(bufnr) then
		M.stop(bufnr)
	else
		M.start(bufnr)
	end
end

-- Completely destroy this buffer's preview session:
--
--   compiler + Zathura + temporary PDF.
function M.close(bufnr)
	bufnr = bufnr or current_buf()

	cleanup(bufnr)

	vim.notify("Typst preview closed")
end

-- Useful while learning/debugging the plugin.
function M.status(bufnr)
	bufnr = bufnr or current_buf()

	local client = get_preview_client(bufnr)
	local viewer = viewer_is_running(bufnr)
	local tempdir = state.tempdirs[bufnr]

	local pdf = tempdir and (tempdir .. "/preview.pdf") or nil

	local lines = {
		"Typst preview status:",
		"  buffer: " .. bufnr,
		"  live export: " .. (client and "running" or "stopped"),
		"  Zathura: " .. (viewer and "running" or "stopped"),
		"  PDF: " .. (pdf or "not created"),
	}

	vim.notify(table.concat(lines, "\n"))
end

-- ---------------------------------------------------------------------------
-- Neovim integration
-- ---------------------------------------------------------------------------

function M.setup()
	-- User commands.
	vim.api.nvim_create_user_command("TypstPreview", function()
		M.start()
	end, {
		desc = "Start Typst live preview",
	})

	vim.api.nvim_create_user_command("TypstPreviewStop", function()
		M.stop()
	end, {
		desc = "Stop Typst live export but leave Zathura open",
	})

	vim.api.nvim_create_user_command("TypstPreviewToggle", function()
		M.toggle()
	end, {
		desc = "Toggle Typst live preview",
	})

	vim.api.nvim_create_user_command("TypstPreviewClose", function()
		M.close()
	end, {
		desc = "Close Typst preview and delete temporary output",
	})

	vim.api.nvim_create_user_command("TypstPreviewStatus", function()
		M.status()
	end, {
		desc = "Show Typst preview status",
	})

	-- An augroup lets all autocmds belonging to this mini-plugin live under
	-- one name and prevents accidental duplication if the setup is changed.
	local group = vim.api.nvim_create_augroup("TypstLivePreview", {
		clear = true,
	})

	-- Only Typst buffers override <leader>mp.
	--
	-- Your global Markdown/Knap mapping remains untouched everywhere else.
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "typst",

		callback = function(ev)
			vim.keymap.set("n", "<leader>mp", function()
				M.toggle(ev.buf)
			end, {
				buffer = ev.buf,
				desc = "Toggle Typst live preview",
			})
		end,
	})

	-- When the buffer truly disappears, there is no reason to keep its
	-- compiler, viewer, or temporary PDF.
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,

		callback = function(ev)
			if state.previews[ev.buf] or state.tempdirs[ev.buf] or state.viewers[ev.buf] then
				cleanup(ev.buf)
			end
		end,
	})

	-- Last-resort cleanup when Neovim itself exits.
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,

		callback = function()
			local buffers = {}

			for bufnr in pairs(state.previews) do
				buffers[bufnr] = true
			end

			for bufnr in pairs(state.tempdirs) do
				buffers[bufnr] = true
			end

			for bufnr in pairs(state.viewers) do
				buffers[bufnr] = true
			end

			for bufnr in pairs(buffers) do
				cleanup(bufnr)
			end
		end,
	})
end

-- Because this is a personal config module rather than a reusable external
-- plugin, configure it immediately when require("typst") loads this file.
M.setup()

return M

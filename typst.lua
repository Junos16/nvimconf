local watch_jobs = {}
local generations = {}

local function stop_watch(bufnr)
	local job = watch_jobs[bufnr]

	if job then
		vim.fn.jobstop(job)
		watch_jobs[bufnr] = nil
	end

	generations[bufnr] = nil

	pcall(vim.api.nvim_del_augroup_by_name, "TypstWatch_" .. bufnr)
end

local function start_watch(bufnr)
	local source = vim.api.nvim_buf_get_name(bufnr)

	if not source:match("%.typ$") then
		vim.notify("Current buffer is not a Typst file", vim.log.levels.ERROR)
		return
	end

	if watch_jobs[bufnr] then
		vim.notify("Typst watch is already running")
		return
	end

	-- Ensure the compiler starts from the current contents.
	vim.cmd("silent write")

	local pdf = source:gsub("%.typ$", ".pdf")

	local job = vim.fn.jobstart({
		"typst",
		"watch",
		source,
		pdf,
	}, {
		on_exit = function()
			watch_jobs[bufnr] = nil
		end,
	})

	if job <= 0 then
		vim.notify("Could not start typst watch", vim.log.levels.ERROR)
		return
	end

	watch_jobs[bufnr] = job
	generations[bufnr] = 0

	-- Only THIS buffer gets automatic writes.
	local group = vim.api.nvim_create_augroup("TypstWatch_" .. bufnr, { clear = true })

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = group,
		buffer = bufnr,

		callback = function()
			generations[bufnr] = (generations[bufnr] or 0) + 1

			local generation = generations[bufnr]

			vim.defer_fn(function()
				if generations[bufnr] ~= generation then
					return
				end

				if not watch_jobs[bufnr] then
					return
				end

				if not vim.api.nvim_buf_is_valid(bufnr) then
					return
				end

				if not vim.bo[bufnr].modified then
					return
				end

				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("silent update")
				end)
			end, 150)
		end,
	})

	-- Stop the watcher automatically when the buffer disappears.
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		buffer = bufnr,
		once = true,

		callback = function()
			stop_watch(bufnr)
		end,
	})

	-- Zathura only needs to be launched once.
	vim.fn.jobstart({
		"zathura",
		pdf,
	}, {
		detach = true,
	})

	vim.notify("Typst live preview started")
end

vim.api.nvim_create_user_command("TypstWatch", function()
	start_watch(vim.api.nvim_get_current_buf())
end, {})

vim.api.nvim_create_user_command("TypstWatchStop", function()
	stop_watch(vim.api.nvim_get_current_buf())
	vim.notify("Typst live preview stopped")
end, {})

vim.keymap.set("n", "<leader>mp", "<cmd>TypstWatch<cr>", { desc = "Start Typst live preview" })

vim.keymap.set("n", "<leader>ms", "<cmd>TypstWatchStop<cr>", { desc = "Stop Typst live preview" })

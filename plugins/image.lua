return {
	"3rd/image.nvim",
	opts = {
		backend = "sixel", -- Best for Foot terminal
		processor = "magick_cli",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = true, -- Hide while typing to avoid flashing
				download_remote_images = true,
				only_render_image_at_cursor = true, -- Only render where you are looking
				filetypes = { "markdown", "vimwiki" },
			},
		},
		max_width = 100,
		max_height = 12,
		max_width_window_percentage = math.huge,
		max_height_window_percentage = math.huge,
		window_overlap_clear_enabled = true, -- Helps with Wayland/Foot stability
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "molten_output", "" },
		editor_only_render_when_focused = true,
		tmux_show_only_in_active_window = false,
		hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
	},
}

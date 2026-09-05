return {
	"HakonHarnes/img-clip.nvim",
	cmd = "PasteImage",
	opts = {
		default = {
			dir_path = "assets",
			extension = "png",
			file_name = "%Y-%m-%d-%H-%M-%S",
			use_absolute_path = false,
			relative_to_current_file = true,
			process_cmd = "convert - -quality 85 png:-",
		},
		filetypes = {
			markdown = {
				url_encode_path = true,
				template = "![$CURSOR]($FILE_PATH)",
				insert_mode_after_paste = true,
			},
			tex = {
				template = [[
\begin{figure}[ht]
  \centering
  \includegraphics[width=0.8\textwidth]{$FILE_PATH}
  \caption{$CURSOR}
  \label{fig:$FILE_NAME}
\end{figure}
]],
			},
		},
	},
	keys = {
		{ "<leader>mi", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
	},
}

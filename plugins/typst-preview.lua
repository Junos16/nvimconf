return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function()
      require("typst-preview").update()
    end,
    opts = {
      -- Automatically open the browser on start
      open_cmd = nil, -- Uses default browser
    },
  },
}

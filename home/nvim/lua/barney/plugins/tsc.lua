return {
  "dmmulroy/tsc.nvim",
  ft = { "typescript", "javascript" },
  config = function()
    local tsc = require("tsc")
    tsc.setup()
  end,
}

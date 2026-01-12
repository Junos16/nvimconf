package.path = vim.fn.stdpath('config') .. '/?.lua;' .. package.path

require('options')
require('lazy_setup')
require('keymaps')

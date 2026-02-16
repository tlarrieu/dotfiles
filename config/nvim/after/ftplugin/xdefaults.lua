local runner = require('runner')
runner.default({ main = runner.term("xrdb ~/.Xresources", { open = false }) })

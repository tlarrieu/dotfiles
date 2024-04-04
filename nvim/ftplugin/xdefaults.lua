local runner = require('runner')
runner.default({ main = runner.exec(":call jobstart('xrdb ~/.Xresources')") })

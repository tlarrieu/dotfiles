local runner = require('runner')
runner.default({
  main = runner.exec("call gnuplot#plot(expand('%'), 'bars')"),
  alt = runner.exec("call gnuplot#plot(expand('%'), 'lines')"),
})

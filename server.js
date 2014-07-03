var debug = require('debug')('server');
var cluster = require('cluster');
if (cluster.isMaster) {
  require('os').cpus().forEach(function () { cluster.fork() });
  cluster.on('exit', function (worker, status) { cluster.fork(); })
  debug('master loaded');
  return;
}

var service = require('./service');
service.listen(service.app.get('port'), function (err) {
  if (err) {
    console.error(err);
    return process.exit(1);
  }
  console.log('app running on port %s', service.app.get('port'));
});
debug('worker loaded');

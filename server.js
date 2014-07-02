var debug = require('debug')('server');
var cluster = require('cluster');
if (cluster.isMaster) {
  require('os').cpus().forEach(function () { cluster.fork() });
  cluster.on('exit', function (worker, status) { cluster.fork(); })
  return;
}

var server = require('./app');
server.listen(server.app.get('port'), function (err) {
  if (err) {
    console.error(err);
    return process.exit(1);
  }
  console.log('app running on port %s', server.app.get('port'));
});


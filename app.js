var debug = require('debug')('app');
var http = require('http');
/*
var expressSession = require('express-session');
var session = require('bus.io-session')();

var express = require('express');
console.log('app', app);
var app = express();
app.set('port', process.env.PORT || 3000);
app.use(expressSession(session.config));
app.use(express.static(__dirname + '/public'));

var server = require('http').Server(app);

var bus = require('bus.io')(server);
bus.use(session);
bus.socket(function (sock) {
  bus.alias(sock, 'everyone');
});
bus.in(function (msg, sock, next) {
  msg.target('everyone');
  next();
});

server.app = app;
server.bus = bus;

module.exports = server;
*/
var expressSession = require('express-session');
var session = require('bus.io-session')();

var express = require('express');
var app = express();
app.set('port', process.env.PORT || 3000);
app.use(expressSession(session.config));
app.use(express.static(__dirname+'/public'));

var server = module.exports = http.Server(function (req, res) { res.writeHead('200').end(); });

var bus = require('bus.io')(server);
bus.use(session);
bus.actor(function (sock, cb) { cb(null, sock.id) });
bus.target(function (sock, params, cb) { cb(null, 'everyone') });

server.app = app;
server.bus = bus;

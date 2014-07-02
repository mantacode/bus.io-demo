var debug = require('debug')('app');

var expressSession = require('express-session');
var connectRedis = require('connect-redis')(expressSession);
var config = { session: { secret:'secret', key: 'bus.io', store: new connectRedis() } };
var session = require('bus.io-session');

var express = require('express');
var app = express();
app.set('port', process.env.PORT || 3000);
app.use(expressSession(config.session));
app.use(express.static(__dirname + '/public'));

var server = require('http').Server(app);

var bus = require('bus.io')(server);
bus.use(session(config.session));
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

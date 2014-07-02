var debug = require('debug')('app');
var express = require('express');
var app = express();
app.set('port', process.env.PORT || 3000);
app.use(express.static(__dirname + '/public'));

var server = require('http').Server(app);

var bus = require('bus.io')(server);

server.app = app;
server.bus = bus;

module.exports = server;
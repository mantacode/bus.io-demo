var debug = require('debug')('service');
var http = require('http');

var app = require('./app');
var bus = require('./bus');

var service = http.Server(app);
service.app = app;
service.bus = bus;

bus.listen(service);

module.exports = service;

debug('loaded');

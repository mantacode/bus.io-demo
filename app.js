var debug = require('debug')('app');

var middleware = require('./lib').middleware;
var app = require('express')();
app.set('port', process.env.PORT || 3000);
app.use(middleware.session);
app.use(middleware.statics);
module.exports = app;

debug('loaded');

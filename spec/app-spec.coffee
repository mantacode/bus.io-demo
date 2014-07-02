EventEmitter = require('events').EventEmitter
request = require('supertest')
http = require('http')
busio = require('bus.io')

describe 'the app', ->

  Given -> @app = require './../app'
  
  describe 'should be an http.Server', ->

    Then -> expect(@app instanceof http.Server).toBe true

  describe 'should have an app', =>

    Then -> expect(typeof @app.app).toBe 'function'

  describe 'should have a bus', =>

    Then -> expect(@app.bus instanceof require('bus.io').Server).toBe true

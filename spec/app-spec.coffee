EventEmitter = require('events').EventEmitter
Message = require('bus.io-common').Message
request = require('supertest')
driver = require('bus.io-driver')
http = require('http')

describe.only 'the service', ->

  Given -> @eapp = jasmine.createSpyObj 'app', ['set', 'use']
  Given -> @express  = jasmine.createSpy('express').andReturn @eapp
  Given -> @esesson = jasmine.createSpy 'expressSession'
  Given -> @expressSession = jasmine.createSpy('express-session').andReturn @esession
  Given -> @estatic = jasmine.createSpy 'static'
  Given -> @express.static = jasmine.createSpy('static').andReturn @estatic
  Given -> @bus = jasmine.createSpyObj 'bus', ['use','in','on','out','actor','target', 'alias','unalias']
  Given -> @busio = jasmine.createSpy('bus.io').andReturn @bus
  Given -> @bsession = jasmine.createSpy 'session'
  Given -> @bsession.config = {}
  Given -> @busSession = jasmine.createSpy('bus.io-session').andReturn @bsession

  Given -> @app = requireSubject 'app', {
    express: @express
    'express-session': @expressSession
    'bus.io': @busio
    'bus.io-session': @busSession
  }

  Given -> @sock = jasmine.createSpyObj 'sock', ['emit']
  Given -> @sock.id = 1
  Given -> @cb = jasmine.createSpy 'cb'

  describe 'is an http.Server', ->

    Then -> expect(@app instanceof http.Server).toBe true

  describe 'has an express app', ->

    Then -> expect(@app.app).toBe @eapp

  describe 'express app', ->

    Given -> @app = @app.app

    describe 'sets the port', ->

      Then -> expect(@app.set).toHaveBeenCalledWith 'port', jasmine.any(Number)

    describe 'uses an express session', ->

      Then -> expect(@expressSession).toHaveBeenCalledWith @bsession.config
      And -> expect(@app.use).toHaveBeenCalledWith @esession

    describe 'that uses an express static resource handler', ->

      Then -> expect(@express.static).toHaveBeenCalledWith jasmine.any(String)
      And -> expect(@app.use).toHaveBeenCalledWith @estatic

  describe 'has a bus', ->

    Then -> expect(@app.bus).toBe @bus

  describe 'bus', ->

    Given -> @bus = @app.bus

    describe 'uses a session', ->

      Then -> expect(@busSession).toHaveBeenCalled()
      And -> expect(@bus.use).toHaveBeenCalledWith @bsession

    describe 'sets the actor function', ->

      Then -> expect(@bus.actor).toHaveBeenCalledWith jasmine.any(Function)

    describe 'actor function calls back with the socket.id', ->

      Given -> @bus.actor = (sock, cb) -> cb null, sock.id
      When -> @bus.actor @sock, @cb
      Then -> expect(@cb).toHaveBeenCalledWith null, @sock.id

    describe 'sets the target function', ->

      Then -> expect(@bus.target).toHaveBeenCalledWith jasmine.any(Function)

    describe 'target function calls back with "everyone"', ->

      Given -> @bus.target = (sock, params, cb) -> cb null, 'everyone'
      When -> @bus.target @sock, {}, @cb
      Then -> expect(@cb).toHaveBeenCalledWith null, 'everyone'

### 

  describe 'should have an app', ->

    Then -> expect(typeof @app.app).toBe 'function'
    And -> expect(@app).toBe @express

  describe 'should have a bus', ->

    Then -> expect(@app.bus instanceof require('bus.io').Server).toBe true

  describe 'bus', ->

    Given ->
      console.log @app
      @bus = @app.bus

    describe 'supports message', ->

      describe 'chat', ->

        Given -> @msg = Message().action('chat')
        When (done) ->
          driver(@bus)
            .in(@msg)
            .done (err, msg) ->
              if err?
                done err
              else
                @res = msg
                done()
        Then -> expect(@res.target()).toBe 'everyone'
          
    describe 'alias a socket to "everyone"', ->

      Given -> spyOn(@bus.io(), 'emit').andCallThrough()
      Given -> spyOn @bus, 'alias'
      When -> @bus.io().emit 'connection', @sock
      Then -> expect(@app.bus.alias).toHaveBeenCalledWith @sock, 'everyone'
###

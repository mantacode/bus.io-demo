EventEmitter = require('events').EventEmitter
Message = require('bus.io-common').Message
request = require('supertest')
http = require('http')
driver = require('bus.io-driver')

describe.only 'the app', ->

  Given -> @app = require './../app', {}
  Given -> @sock = new EventEmitter
  Given -> @sock.id = 1
  
  describe 'should be an http.Server', ->

    Then -> expect(@app instanceof http.Server).toBe true

  describe 'should have an app', ->

    Then -> expect(typeof @app.app).toBe 'function'

  describe 'should have a bus', ->

    Then -> expect(@app.bus instanceof require('bus.io').Server).toBe true

  describe 'bus', ->

    Given -> @bus = @app.bus

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
        Then -> expect(@msg.target()).toBe 'everyone'
          
    describe 'alias a socket to "everyone"', ->

      Given -> spyOn(@bus.io(), 'emit').andCallThrough()
      Given -> spyOn @bus, 'alias'
      When -> @bus.io().emit 'connection', @sock
      Then -> expect(@app.bus.alias).toHaveBeenCalledWith @sock, 'everyone'

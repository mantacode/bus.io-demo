EventEmitter = require('events').EventEmitter
Message = require('bus.io-common').Message
request = require('supertest')
http = require('http')
busio = require('bus.io')
driver = require('bus.io-driver')

describe 'the app', ->

  Given -> @app = require './../app'
  
  describe 'should be an http.Server', ->

    Then -> expect(@app instanceof http.Server).toBe true

  describe 'should have an app', ->

    Then -> expect(typeof @app.app).toBe 'function'

  describe 'should have a bus', ->

    Then -> expect(@app.bus instanceof require('bus.io').Server).toBe true

  describe 'bus', ->

    Given -> @bus = @app.bus

    describe 'supports these messages', ->

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

       Given -> @sock = new EventEmitter
       Given -> @sock.id = 1
       Given -> spyOn(@bus.io(), 'emit').andCallThrough()
       Given -> spyOn @bus, 'alias'
       When -> @bus.io().emit 'connection', @sock
       Then -> expect(@app.bus.alias).toHaveBeenCalledWith @sock, 'everyone'


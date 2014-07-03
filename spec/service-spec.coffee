describe.only 'service', ->

  Given -> @http = jasmine.createSpyObj 'http', ['Server']
  Given -> @server = ->
  Given -> @http.Server.andReturn new @server()
  Given -> @app = jasmine.createSpy 'app'
  Given -> @bus = jasmine.createSpyObj 'bus', ['listen']
  Given -> @service = requireSubject 'service', {
    'http': @http
    './app': @app
    './bus': @bus
  }

  describe 'has an app', ->

    Then -> expect(@service.app).toBe @app

  describe 'is an http.Server using "app" for its handler', ->

    Then -> expect(@http.Server).toHaveBeenCalledWith @app
    #And -> expect(@service instanceof @server).toBe true

  describe 'has a bus', ->

    Then -> expect(@service.bus).toBe @bus

  describe 'bus listening to service', ->

    Then -> expect(@service.bus.listen).toHaveBeenCalledWith @service
###

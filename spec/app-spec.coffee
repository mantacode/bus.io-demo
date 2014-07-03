describe 'the app', ->

  Given -> @eapp = jasmine.createSpyObj 'app', ['set', 'use']
  Given -> @express  = jasmine.createSpy('express').andReturn @eapp
  Given -> @lib = middleware: jasmine.createSpyObj 'middleware', ['session','statics']

  Given -> @app = requireSubject 'app', {
    express: @express
    './lib': @lib
  }

  describe 'is expess', ->

    Then -> expect(@express).toHaveBeenCalled()
    And -> expect(@app).toBe @eapp

  describe 'sets the port', ->

    Then -> expect(@app.set).toHaveBeenCalledWith 'port', jasmine.any(Number)

  describe 'uses session middleware', ->

    Then -> expect(@app.use).toHaveBeenCalledWith @lib.middleware.session

  describe 'uses session middleware', ->

    Then -> expect(@app.use).toHaveBeenCalledWith @lib.middleware.statics

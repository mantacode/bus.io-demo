EventEmitter = require('events').EventEmitter

describe 'the server', ->

  describe 'master process', ->

    Given -> @cluster = new EventEmitter
    Given -> @cluster.fork = ->
    Given -> @cluster.isMaster = true
    Given -> spyOn @cluster, 'fork'
    Given -> spyOn(@cluster, 'on').andCallThrough()
    Given -> @os = cpus: -> [{},{},{},{}]
    Given -> @server = requireSubject 'server', {
      cluster: @cluster
      os: @os
    }

    describe 'should fork off children', ->

      Then -> expect(@cluster.fork.calls.length).toBe @os.cpus().length

    describe 'should bind an exit event that forks children', ->

      When -> @cluster.emit 'exit'
      Then -> expect(@cluster.on).toHaveBeenCalledWith 'exit', jasmine.any(Function)
      And -> expect(@cluster.fork).toHaveBeenCalled()

  describe 'child process', ->

    Given -> @service =
      app:
        get: -> 3000
      listen: ->
    Given -> spyOn @service, 'listen'

    Given ->
      @server = requireSubject 'server', {
        cluster: isMaster: false
        './service': @service
      }

    describe 'should call listen', ->

      Then -> expect(@service.listen).toHaveBeenCalledWith jasmine.any(Number), jasmine.any(Function)

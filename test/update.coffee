
should = require('should')


module.exports = (apiMod, db, addr, request) ->

  _handler =
    init: (request) ->
      on: (event, handler) ->
        handler({statusCode: 200})
    onResponse: (response, handler, cb) ->
      handler {uid: 11, desc: 'pokus1', amount: 300}, ->
        handler {uid: 11, desc: 'pokus2', amount: -100}, ->
          cb()

  _lastState = 200

  it "shall update", (done) ->
    updater = apiMod.startUpdating db, _handler
    updater.on 'bankaccountchecked', ->
      request.get "#{addr}/", (err, res, body) ->
        return done err if err
        res.statusCode.should.eql 200
        body = JSON.parse(body)
        body.uid.should.eql 11
        body.state.should.eql _lastState + 200
        done()
    updater.doUpdate()


should = require('should')


module.exports = (apiMod, db, addr, request) ->

  _data = [
    {uid: 11, desc: 'pokus1', amount: 300, createdAt: new Date(100)},
    {uid: 11, desc: 'pokus2', amount: -100, createdAt: new Date(1000)}
  ]

  _handler =
    init: (request) ->
      on: (event, handler) ->
        handler({statusCode: 200})
    onResponse: (response, handler, cb) ->
      handler _data[0], ->
        handler _data[1], ->
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

  it "shall update credit account and save change into history", (done) ->
    change =
      uid: 11
      amount: -300
      desc: "Gandalf's hat"

    apiMod.updateCredit db, change, (err, data) ->
      return done(err) if err

      request.get "#{addr}/", (err, res, body) ->
        return done err if err
        res.statusCode.should.eql 200
        body = JSON.parse(body)
        body.uid.should.eql 11
        body.state.should.eql _lastState + 200 - 300
        done()

      # request.get "#{addr}/history", (err, res, body) ->
      #   return done err if err
      #   res.statusCode.should.eql 200
      #   body = JSON.parse(body)
      #   body.uid.should.eql 11
      #   body.state.should.eql _lastState + 200 - 300
      #   done()

  it "must not to make any update on insufficient funds", (done) ->
    change =
      uid: 11
      amount: -3000
      desc: "Gandalf's cloack"

    apiMod.updateCredit db, change, (err, data) ->
      return done("must not pass!") if not err

      err.should.eql "insufficient funds!"

      request.get "#{addr}/", (err, res, body) ->
        return done err if err
        res.statusCode.should.eql 200
        body = JSON.parse(body)
        body.uid.should.eql 11
        body.state.should.eql _lastState + 200 - 300
        done()

      #TODO check history has not changed

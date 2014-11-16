
should = require('should')


module.exports = (apiMod, db, addr, request) ->

  _data = [
    {uid: 11, desc: 'pokus1', amount: 300, createdAt: new Date(100)},
    {uid: 11, desc: 'pokus2', amount: -100, createdAt: new Date(1000)}
  ]

  _accessor = (done) ->
    done(_data)

  _lastState = 200

  it "shall update", (done) ->
    updater = apiMod.startUpdating db, _accessor
    updater.on 'updated', ->
      request.get "#{addr}/current/11", (err, res, body) ->
        return done err if err
        res.statusCode.should.eql 200
        body = JSON.parse(body)
        body.should.eql 200
        done()
    updater.doUpdate()

  it "shall update credit account and save change into history", (done) ->
    change =
      uid: 11
      amount: -30
      desc: "Gandalf's hat"

    apiMod.update db, change, (err, data) ->
      return done(err) if err

      request.get "#{addr}/current/11", (err, res, body) ->
        return done err if err
        res.statusCode.should.eql 200
        body = JSON.parse(body)
        body.should.eql _lastState + change.amount
        done()

  it "must not to make any update on insufficient funds", (done) ->
    change =
      uid: 11
      amount: -3000
      desc: "Gandalf's cloack"

    apiMod.update db, change, (err, data) ->
      return done("must not pass!") if not err

      err.should.eql "insufficient funds!"

      request.get "#{addr}/current/11", (err, res, body) ->
        return done err if err
        res.statusCode.should.eql 200
        body = JSON.parse(body)
        body.should.eql 170
        done()

      #TODO check history has not changed

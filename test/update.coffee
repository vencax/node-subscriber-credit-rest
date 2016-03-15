
should = require('should')
request = require('request').defaults({timeout: 50000})


module.exports = (g) ->

  addr = g.baseurl

  _lastState = 0

  it "shall update credit account and save change into history", (done) ->
    change =
      uid: 11
      amount: 300
      desc: "Gandalf's hat"

    g.apiMod.update change, (err, data) ->
      return done(err) if err

      request.get "#{addr}/state/11", (err, res, body) ->
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

    g.apiMod.tryUpdateCredit change, (err, data) ->
      return done("must not pass!") if not err

      err.should.eql "insufficient funds!"

      request.get "#{addr}/state/11", (err, res, body) ->
        return done err if err
        res.statusCode.should.eql 200
        body = JSON.parse(body)
        body.should.eql 300
        done()

      #TODO check history has not changed

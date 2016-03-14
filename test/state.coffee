
should = require('should')
request = require('request').defaults({timeout: 50000})


module.exports = (g) ->

  addr = g.baseurl

  it "must return current account balance", (done) ->

    account =
      uid: 11
      state: 300

    request.get "#{addr}/state/11", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      body = JSON.parse(body)
      body.should.eql account.state
      done()

  it "must return history items", (done) ->

    account =
      uid: 11
      state: 170

    request.get "#{addr}/history", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      body = JSON.parse(body)
      body.length.should.eql 1
      done()


should = require('should')


module.exports = (port, request) ->

  s = "http://localhost:#{port}/api"

  it "must return current account balance", (done) ->

    data =
      uid: 11
      state: 200

    request.get "#{s}/", (err, res) ->
      return done err if err
      res.statusCode.should.eql 200
      res.body.should.eql data
      done()

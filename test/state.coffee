
should = require('should')


module.exports = (db, addr, request) ->

  it "must return current account balance", (done) ->

    account =
      uid: 11
      state: 200

    db.CreditAccount.create(account).on 'success', (account) ->

      request.get "#{addr}/", (err, res, body) ->
        return done err if err
        res.statusCode.should.eql 200
        body = JSON.parse(body)
        body.uid.should.eql account.uid
        body.state.should.eql account.state
        done()

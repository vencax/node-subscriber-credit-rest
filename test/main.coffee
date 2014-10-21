
should = require('should')
http = require('http')
request = require('request').defaults({timeout: 5000})
fs = require('fs')
bodyParser = require('body-parser')
express = require('express')

port = process.env.PORT || 3333


# entry ...
describe "app", ->

  # init server
  app = []
  server = []

  before (done) ->
    app = express()
    app.use(bodyParser.urlencoded({ extended: false }))
    app.use(bodyParser.json())

    db =
      Sequelize: require('sequelize')

    db.sequelize = new db.Sequelize('database', 'username', 'password',
      # sqlite! now!
      dialect: 'sqlite'
    )
    require(__dirname + '/../models.js')(db)

    db.sequelize.sync().on 'success', () ->

      account =
        uid: 11
        state: 0

      db.CreditAccount.create(account).on 'success', (account) ->

        _prepareReq = (request) ->
          on: (event, handler) ->
            handler({statusCode: 200})

        _parseResp = (response, handler) ->
          handler({uid: 11, desc: 'pokus1', amount: 300})
          handler({uid: 11, desc: 'pokus2', amount: -100})

        apiM = require(__dirname + '/../index')
        api = apiM db, _prepareReq, _parseResp, () ->
          done()

        app.use (req, res, next) ->
          req.user =
            id: 11
          next()

        app.use('/api', api)

        server = app.listen port, (err) ->
          return done(err) if err


  after (done) ->
    server.close()
    done()

  it "should exist", (done) ->
    should.exist app
    done()

  # run the rest of tests
  require('./state')(port, request)

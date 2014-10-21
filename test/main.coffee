
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

    Sequelize = require('sequelize')
    sequelize = new Sequelize('database', 'username', 'password',
      # sqlite! now!
      dialect: 'sqlite'
    )
    .authenticate()
    .complete (err) ->
      return done("Unable to connect to the database: #{err}") if err

      api = require(__dirname + '/../index')(sequelize
      , (request) ->
        on: (event, handler) ->
          handler({statusCode: 200})
      , (response) ->
        (response, handler) ->
          handler({uid: 11, desc: 'pokus1', amount: 300})
          handler({uid: 11, desc: 'pokus2', amount: -100})
      )
      app.use('/api', api)

      server = app.listen port, (err) ->
        return done(err) if err
        done()

  after (done) ->
    server.close()
    done()

  it "should exist", (done) ->
    should.exist app
    done()

  # run the rest of tests
  require('./state')(port, request)


should = require('should')
http = require('http')
request = require('request').defaults({timeout: 5000})
fs = require('fs')
bodyParser = require('body-parser')
express = require('express')

port = process.env.PORT || 3333


# entry ...
describe "app", ->

  apiMod = require(__dirname + '/../index')
  g = {}
  db =
    Sequelize: require('sequelize')

  before (done) ->
    # init server
    app = express()
    app.use(bodyParser.urlencoded({ extended: false }))
    app.use(bodyParser.json())

    db.sequelize = new db.Sequelize('database', 'username', 'password',
      # sqlite! now!
      dialect: 'sqlite'
    )
    require(__dirname + '/../models.js')(db) # register models

    db.sequelize.sync().on 'success', () ->

      api = apiMod.app db

      app.use (req, res, next) ->
        req.user =
          id: 11
        next()

      app.use('/api', api)

      g.server = app.listen port, (err) ->
        return done(err) if err
        done()

      g.app = app

  after (done) ->
    g.server.close()
    done()

  it "should exist", (done) ->
    should.exist g.app
    done()

  # run the rest of tests
  baseurl = "http://localhost:#{port}/api"

  require('./state')(db, baseurl, request)
  require('./update')(apiMod, db, baseurl, request)


should = require('should')
http = require('http')
request = require('request').defaults({timeout: 50000})
fs = require('fs')
bodyParser = require('body-parser')
express = require('express')

port = process.env.PORT || 3333


# entry ...
describe "app", ->

  apiMod = require(__dirname + '/../index')
  g = {}
  Sequelize = require('sequelize')

  before (done) ->
    # init server
    app = express()
    app.use(bodyParser.urlencoded({ extended: false }))
    app.use(bodyParser.json())

    sequelize = new Sequelize 'database', 'username', 'password',
      # sqlite! now!
      dialect: 'sqlite'
    g.sequelize = sequelize

    # register models
    mdls = require(__dirname + '/../models')(sequelize, Sequelize)

    sequelize.sync({ logging: console.log }).then () ->
      g.apiMod = apiMod(sequelize.models)

      api = express()
      api = g.apiMod.initApp(api)

      app.use (req, res, next) ->
        req.user =
          id: 11
        next()

      app.use('/api', api)

      g.server = app.listen port, (err) ->
        return done(err) if err
        done()

      g.app = app
    .catch (err)->
      done(err)

  after (done) ->
    g.server.close()
    done()

  it "should exist", (done) ->
    should.exist g.app
    done()

  # run the rest of tests
  g.baseurl = "http://localhost:#{port}/api"

  require('./update')(g)
  require('./state')(g)

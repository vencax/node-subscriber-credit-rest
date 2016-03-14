State = require('./controllers/state')

# create API app -------------------------------------------------------------
module.exports = (app, models) ->

  routes = State(models)

  app.get '/state/:uid', routes.state
  app.get '/history', routes.history

  if process.env.MOCK_TRANSFER
    app.post '/increase', Update.mockincrease(models)

  return app # for chaining

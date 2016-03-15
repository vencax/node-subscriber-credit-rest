State = require('./controllers/state')
Update = require('./controllers/update')

module.exports = (models) ->

  updateCtrls = Update(models)

  update: updateCtrls.update
  tryUpdateCredit: updateCtrls.tryUpdateCredit

  # create API app -------------------------------------------------------------
  initApp: (app) ->

    stateCtrls = State(models)
    updateCtrls = Update(models)

    app.get '/state/:uid', stateCtrls.state
    app.get '/history', stateCtrls.history

    if process.env.MOCK_TRANSFER
      app.post '/increase', updateCtrls.mockincrease

    return app # for chaining

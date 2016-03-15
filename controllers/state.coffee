Utils = require('./utils')

module.exports = (models) ->

  countBalance: (uid)->
    return Utils.countBalance(models, uid)

  state: (req, res, next) ->
    Utils.countBalance(models, req.user.id).then (state)->
      res.json state
    .catch (err)->
      res.status(400).send(err)

  history: (req, res, next) ->
    models.creditchange.findAll(where: uid: req.user.id).then (changes) ->
      res.json changes
    .catch (err)->
      res.status(400).send(err)

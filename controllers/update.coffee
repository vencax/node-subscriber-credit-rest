Utils = require('./utils')


_increase = (change, cb) ->
  #TODO models.sequelize.transaction(function(t) {

  onError = (err) ->
    # t.rollboack();
    cb err, null

  change.save().then (saved) ->
    cb null, saved
  .catch onError

module.exports = (models) ->

  update: (change, cb) ->
    _increase models.creditchange.build(change), cb

  tryUpdateCredit: (change, cb) ->
    Utils.countBalance(models, change.uid).then (state)->
      if state + change.amount < 0
        return cb('insufficient funds!')

      _increase models.creditchange.build(change), cb
    .catch (err)->
      cb(err)

  mockincrease: (req, res, next) ->
    ch = models.creditchange.build
      uid: req.body.uid
      createdAt: new Date()
      desc: 'mock credit increase!'
      amount: req.body.amount
    _increase ch, (err, change) ->
      return res.status(400).send err if err
      res.json change

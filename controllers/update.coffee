Utils = require('./utils')


_increase = (change, cb) ->
  #TODO models.sequelize.transaction(function(t) {

  onError = (err) ->
    # t.rollboack();
    cb err, null

  change.save().then (saved) ->
    cb null, saved
  .catch onError


exports.update = (models, change, done) ->
  _increase models.creditchange.build(change), done


exports.tryUpdateCredit = (models, change, done) ->
  Utils.countBalance(change.uid, models.creditchange).then (state)->
    if state + change.amount < 0
      return done('insufficient funds!')

    _increase models.creditchange.build(change), done
  .catch (err)->
    done(err)


exports.mockincrease = (models) ->
  (req, res, next) ->
    ch = models.creditchange.build
      uid: req.body.uid
      createdAt: new Date()
      desc: 'mock credit increase!'
      amount: req.body.amount
    _increase ch, (err, change) ->
      return res.status(400).send err if err
      res.json change

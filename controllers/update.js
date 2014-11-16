
var EventEmitter = require("events").EventEmitter;
var async = require('async');


var _increase = function(change, cb) {

  //TODO models.sequelize.transaction(function(t) {

  var onError = function(err) {
    // t.rollboack();
    cb(err, null);
  };

  change.save(/*{transaction: t}*/)
    .on('success', function(saved){
      cb(null, saved);
    })
    .on('error', onError);
}

var _doProcessChange = exports.updateCredit = function(models, change, done) {

  models.CreditChange
    .findAll({where: {uid: change.uid}})
    .on('success', function(changes) {
      var state = 0;
      changes.forEach(function(ch) {
        state += ch.amount;
      });

      if (state + change.amount < 0) {
        return done('insufficient funds!');
      }

      _increase(models.CreditChange.build(change), done);
    })
}

exports.getupdater = function(models, accessor) {

  var ee = new EventEmitter();

  ee.doUpdate = function() {
    accessor(function(data) {

      async.each(data, function(change, callback) {

        _increase(models.CreditChange.build(change), callback);

      }, function(err){
        if( err ) {
          ee.emit('updated', err);
        } else {
          ee.emit('updated');
        }
      });

    });
  };

  return ee;
};

exports.mockincrease = function(models) {
  return function(req, res, next) {
    var ch = models.CreditChange.build({
      uid: req.body.uid, createdAt: new Date(),
      desc: 'mock credit increase!', amount: req.body.amount
    });
    _increase(ch, function(err, change) {
      if(err) {
        res.status(400).send(err);
      } else {
        res.json(change);
      }
    })
  };
}

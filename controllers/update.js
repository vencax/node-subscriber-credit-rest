var request = require('request');
var EventEmitter = require("events").EventEmitter;


var _increase = function(account, change, cb) {

  //TODO models.sequelize.transaction(function(t) {

  var onError = function(err) {
    t.rollboack();
    cb(err, null);
  };

  change.save(/*{transaction: t}*/)
    .on('success', function(saved){
      account.state += change.amount;
      account.save(/*{transaction: t}*/)
        .on('success', function() {
          cb(null, account);
        })
        .on('error', onError);
    })
    .on('error', onError);
}

var _doProcessChange = exports.updateCredit = function(models, change, done) {

  models.CreditAccount.find({where: {uid: change.uid}})
    .on('success', function(account) {
      if (!account) {
        return done('account not found');
      }

      if (account.state + change.amount < 0) {
        return done('insufficient funds!');
      }

      _increase(account, models.CreditAccountChange.build(change), done);
    })
}

exports.getupdater = function(models, accounthandler) {

  var ee = new EventEmitter();

  var _processChange = function(change, cb) {
    _doProcessChange(models, change, cb);
  };

  ee.doUpdate = function() {
    accounthandler.init(request)
      .on('response', function(response) {
        if (response.statusCode === 200) {
          accounthandler.onResponse(response, _processChange, function() {
            ee.emit('bankaccountchecked');
          });
        }
      });
  };

  return ee;
};

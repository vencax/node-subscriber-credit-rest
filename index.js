var express = require('express');

var Update = require('./controllers/update');

// create API app -------------------------------------------------------------

exports.app = function(db) {

  var api = module.exports = express();

  var routes = require('./controllers/state')(db);
  api.get('/current/:uid', routes.curr);
  api.get('/history', routes.history);

  if(process.env.MOCK_TRANSFER) {
    api.post('/increase', Update.mockincrease(db));
  }

  return api;
};

exports.startUpdating = function(db, accounthandler) {

  var updater = Update.getupdater(db, accounthandler);

  // default 6 hours
  var interval = process.env.ACCOUNT_UPDATE_INTERVAL || 1000 * 60 * 60 * 6;

  setInterval(function() {
    updater.doUpdate();
  }, interval);

  updater.doUpdate();

  return updater;
}

exports.update = Update.updateCredit;

exports.models = require('./models')

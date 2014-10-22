var express = require('express');


// create API app -------------------------------------------------------------

exports.app = function(db) {

  var api = module.exports = express();

  var routes = require('./controllers/state')(db);
  api.get('/', routes.findAccount, routes.curr);
  api.get('/history/:days', routes.history);

  return api;
};

exports.startUpdating = function(db, accounthandler) {
  var Update = require('./controllers/update')
  var updater = Update.getupdater(db, accounthandler);

  // default 6 hours
  var interval = process.env.ACCOUNT_UPDATE_INTERVAL || 1000 * 60 * 60 * 6;

  setInterval(function() {
    updater.doUpdate();
  }, interval);

  return updater;
}

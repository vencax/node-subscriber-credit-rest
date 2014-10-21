var express = require('express');

// create API app -------------------------------------------------------------

module.exports = function(db, createUpdateReq, onUpdateResponse, done) {

  var api = module.exports = express();

  var routes = require('./controllers/state')(db);
  api.get('/', routes.findAccount, routes.curr);
  api.get('/history/:days', routes.history);

  var updModule = require('./controllers/update');

  // default 6 hours
  var interval = process.env.ACCOUNT_UPDATE_INTERVAL || 1000 * 60 * 60 * 6;

  setInterval(function() {
    updModule.update(db, createUpdateReq, onUpdateResponse);
  }, interval);

  updModule.update(db, createUpdateReq, onUpdateResponse, done);

  return api;
};

var express = require('express');

// create API app -------------------------------------------------------------

module.exports = function(sequelize, createUpdateReq, onUpdateResponse) {
  var models = require('./models');

  var api = module.exports = express();

  var state = require('./controllers/state')(models);
  api.get('/', state.curr);
  api.get('/history/:days', state.history);

  var updModule = require('./controllers/update');
  updModule.update(models, createUpdateReq, onUpdateResponse);

  // default 6 hours
  var interval = process.env.ACCOUNT_UPDATE_INTERVAL || 1000 * 60 * 60 * 6;

  setInterval(function() {
    updModule.update(models, createReq, onUpdateResponse);
  }, interval);

  return api;
};

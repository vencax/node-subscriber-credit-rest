
var Update = require('./controllers/update');

// create API app -------------------------------------------------------------

exports.hookTo = function(app, db) {

  var routes = require('./controllers/state')(db);
  app.get('/current/:uid', routes.curr);
  app.get('/history', routes.history);

  if(process.env.MOCK_TRANSFER) {
    app.post('/increase', Update.mockincrease(db));
  }

  return app;  // for chaining
};

exports.startUpdating = function(db, accounthandler) {

  var updater = Update.getupdater(db, accounthandler);

  // default 6 hours
  var interval = process.env.ACCOUNT_UPDATE_INTERVAL || 1000 * 60 * 60 * 6;

  setInterval(function() {
    updater.doUpdate();
  }, interval);

  return updater;
}

exports.update = Update.updateCredit;

exports.models = require('./models')

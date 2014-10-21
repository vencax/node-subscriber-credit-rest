var request = require('request');


exports.update = function(models, createRequest, onUpdateResponse, done) {

  var _processChange = function(change) {
    models.CreditAccount
      .find({where: {uid: change.uid}})
      .on('success', function(account) {
        if (!account) return;
        models.CreditAccountChange
          .create(change)
          .on('success', function(saved){
            account.increment('state', {by: change.amount});
          });
      })
  };

  createRequest(request)
    .on('response', function(response) {
      if (response.statusCode === 200) {
        onUpdateResponse(response, _processChange);
        if (done) return done();
      }
    });
};

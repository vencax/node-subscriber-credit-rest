var request = require('request');

var onResponse = function(response, models) {
  var r = JSON.parse(response.read());
}

exports.update = function(models, createRequest, onUpdateResponse) {
  createRequest(request)
    .on('response', function(response) {
      if (response.statusCode === 200) {

        onUpdateResponse(response, function(change) {
          console.log(change);
          models.CreditAccountChange.create(change).success(function(saved){
            console.log(saved)
          });
        });

      }
    });
};

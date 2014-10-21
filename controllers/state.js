

module.exports = function(models) {
  return {

    curr: function(req, res, next) {
      var h = {uid: 11, state: 200}
      res.status(200).send(h);
    },

    history: function(req, res, next) {
      var h = [{
        uid: 11,
        desc: 'pokus1',
        amount: 300
      }, {
        uid: 11,
        desc: 'pokus2',
        amount: -100
      }];
      res.status(200).send(h);
    }

  };
};



module.exports = function(models) {
  return {

    findAccount: function(req, res, next) {
      models.CreditAccount
        .find({where: {uid: req.user.id}})
        .on('success', function(account) {
          if (account) {
            req.account = account;
            return next();
          } else {
            return res.status(404).send('account not found');
          }
        })
    },

    curr: function(req, res, next) {
      res.status(200).send(req.account);
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

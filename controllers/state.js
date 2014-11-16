

module.exports = function(models) {

  function _get_changes(uid, done) {
    models.CreditChange
      .findAll({where: {uid: uid}})
      .on('success', done);
  };

  return {

    curr: function(req, res, next) {
      _get_changes(req.user.id, function(changes) {
        var state = 0;
        changes.forEach(function(ch) {
          state += ch.amount;
        });
        res.json(state);
      });
    },

    history: function(req, res, next) {
      _get_changes(req.user.id, function(changes) {
        res.json(changes);
      });
    }

  };
};



module.exports = function(db) {

  db.CreditAccount = db.sequelize.define('CreditAccount', {
    uid: db.Sequelize.INTEGER,
    state: db.Sequelize.FLOAT
  });

  db.CreditAccountChange = db.sequelize.define('CreditAccountChange', {
    uid: db.Sequelize.INTEGER,
    desc: db.Sequelize.STRING,
    amount: db.Sequelize.FLOAT,
    createdAt: db.Sequelize.DATE
  }, {timestamps: false});

};

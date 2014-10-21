

module.exports = function(sequelize) {

  return {

    CreditAccount: sequelize.define('CreditAccount', {
      uid: sequelize.INTEGER,
      state: Sequelize.FLOAT
    }),

    CreditAccountChange: sequelize.define('CreditAccountChange', {
      uid: sequelize.INTEGER,
      desc: Sequelize.STRING,
      amount: Sequelize.FLOAT
    })

  };

};

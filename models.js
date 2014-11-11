

module.exports = function(sequelize, Sequelize) {

  return {

    CreditChange: sequelize.define('CreditChange', {
      uid: Sequelize.INTEGER,
      desc: Sequelize.STRING,
      amount: Sequelize.FLOAT,
      createdAt: Sequelize.DATE
    }, {timestamps: false})
    
  };

};

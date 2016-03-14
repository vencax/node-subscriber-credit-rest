
module.exports = (sequelize, Sequelize) ->

  CreditChange: sequelize.define 'creditchange',
    uid:
      type: Sequelize.INTEGER
      primaryKey: true
    createdAt:
      type: Sequelize.DATE
      primaryKey: true
      defaultValue: Sequelize.NOW
    desc: Sequelize.STRING
    amount: Sequelize.FLOAT
  ,
    timestamps: false
    tableName: 'creditchanges'

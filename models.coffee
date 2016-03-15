
module.exports = (sequelize, Sequelize) ->

  CreditChange: sequelize.define 'creditchange',
    uid:
      type: Sequelize.INTEGER
      primaryKey: true
    createdAt:
      type: Sequelize.DATE
      primaryKey: true
      defaultValue: Sequelize.NOW
    desc:
      type: Sequelize.STRING
      allowNull: false
    amount:
      type: Sequelize.FLOAT
      allowNull: false
  ,
    timestamps: false
    tableName: 'creditchanges'

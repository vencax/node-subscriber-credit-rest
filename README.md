[![build status](https://api.travis-ci.org/vencax/node-dhcp-rest-conf.svg)](https://travis-ci.org/vencax/node-subscriber-credit-rest)

# REST server for subscriber-credit (SC)

Sometimes integration of payment stuff like creditcards etc. etc. is problem.
This package tries to solve this with credit accounts CA that are recharged via banktransfer.
Bank account is regulary checked and incomming trasfers are processed to recharge particular CAs.
The transfer must be identified with unique id UID so it can be assotiated of particular CA.

On the oposite direction the credit is lowered according purchasing some services through api.
Each credit change is stored in DB.

The lib provides REST api for checking CA state hookable as [express app](http://expressjs.com/).
Plus updating functions.

Install with:

	npm install subscriber-credit --save

Offers REST API as an express app that can be hooked just like this:

```javascript
  var Credit = require('subscriber-credit');
  // ...
  var sequelize = ... init sequelize ... models (db must be object of sequelize models)
  // ...
	var credit = Credit(sequelize.models);
  var app = express();
  api.use('/api/credit', credit.initApp(app));
  // ...
```

## credit updating

Tipicaly on transfer to our bank account, so its state has to be checked periodically.
Note that bankaccessor function shall return only records that corresponds to credit recharge.
So you have to write your own.

```javascript
// ...
credit = Credit(sequelize.models);
// ...
var bankaccessor = function(cb) {
	// func returning all relevant items from bank account API and pass them to callback
	// each item object expected like this:
	return [
		{uid: 11, desc: 'credit refueling VencaX', amount: 300, date: date
	}];
};
// we process them in a timer or somth.
bankaccessor(function(records) {
	records.forEach(function(item) {
		credit.update(item, function(err, newRec) {
			// do whaterver on error either on newRec
		});
	});
});
```

If you want to give a feedback, [raise an issue](https://github.com/vencax/node-subscriber-credit-rest/issues).

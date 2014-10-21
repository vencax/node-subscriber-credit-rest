[![build status](https://travis-ci.org/vencax/node-subscriber-credit-rest.svg)](https://travis-ci.org/vencax/node-subscriber-credit-rest)

# REST server for subscriber-credit (SC)

Install with:

	npm install git+https://github.com/vencax/node-subscriber-credit-rest.git --save

Offers REST API as an express app that can be hooked just like this:

	...
	sequelize = ... init sequelize
	...
	var app = express();
	...
	var createBankAPIReq = function(request) {
		// func that shall prepare request for bank account API
	};
	var onBankAPIResponse = function(response, cb) {
		// func that shall parse response from bank account API and call cb on each
		// cb expect change objects:
		// {uid: 11, desc: 'pokus1', amount: 300, date: date}
	};
	var api = require('node-subscriber-credit-rest')(sequelize, createBankAPIReq, onBankAPIResponse);
	api.use('/api/credit', api);

If you want to give a feedback, [raise an issue](https://github.com/vencax/node-subscriber-credit-rest/issues).

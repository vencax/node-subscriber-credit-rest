[![build status](https://api.travis-ci.org/vencax/node-dhcp-rest-conf.svg)](https://travis-ci.org/vencax/node-subscriber-credit-rest)

# REST server for subscriber-credit (SC)

Install with:

	npm install git+https://github.com/vencax/node-subscriber-credit-rest.git --save

Offers REST API as an express app that can be hooked just like this:

	...
	sequelize = ... init sequelize
	...
	var app = express();
	...
	var bankaccessor = function(done) {
		// func that shall all relevan items from bank account API and pass them to done
		// each item object expected like this:
		// {uid: 11, desc: 'pokus1', amount: 300, date: date}
	};
	var api = require('node-subscriber-credit-rest')(sequelize, bankaccessor);
	api.use('/api/credit', api);

If you want to give a feedback, [raise an issue](https://github.com/vencax/node-subscriber-credit-rest/issues).

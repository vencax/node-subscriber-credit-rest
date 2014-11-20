[![build status](https://api.travis-ci.org/vencax/node-dhcp-rest-conf.svg)](https://travis-ci.org/vencax/node-subscriber-credit-rest)

# REST server for subscriber-credit (SC)

Sometimes integration of payment stuff like creditcards etc. etc. is problem.
This package tries to solve this with credit accounts CA that are recharged via banktransfer.
Bank account is regulary checked and incomming trasfers are processed to recharge particular CAs.
The transfer must be identified with unique id UID so it can be assotiated of particular CA.

On the oposite direction the credit is lowered according purchasing some services through api.
Each credit change is stored in DB.

The lib provides account checking stuff (updating).
As well as REST api for checking CA state hookable as [express app](http://expressjs.com/).

Install with:

	npm install subscriber-credit --save

Offers REST API as an express app that can be hooked just like this:

```javascript
  var Credit = require('subscriber-credit');
  // ...
  var db = ... init sequelize ... models (db must be object of sequelize models)
  // ...
  var app = express();
  api.use('/api/credit', Credit.hookTo(app, db));
  // ...
  // init the updating stuff
  var bankaccessor = function(done) {
    // func that shall all relevant items from bank account API and pass them to done
    // each item object expected like this:
    return [
      {uid: 11, desc: 'credit refueling VencaX', amount: 300, date: date
    }];
  };
  Credit.startUpdating(db, bankaccessor);
```
  
Note that bankaccessor function shall return only records that corresponds to credit recharge.
So you have to write your own.

If you want to give a feedback, [raise an issue](https://github.com/vencax/node-subscriber-credit-rest/issues).

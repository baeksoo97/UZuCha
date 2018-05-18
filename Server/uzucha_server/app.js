// app.js

// [LOAD PACKAGES]
var express     = require('express');
var app         = express();
var bodyParser  = require('body-parser');
var mongoose    = require('mongoose');

// 변수
var mongoURL = 'mongodb://localhost:27017/UzuChaDB'
// [CONFIGURE SERVER PORT]
var port = process.env.PORT || 8091;


// [CONFIGURE mongoose ]
var db = mongoose.connection;
db.on('error', console.error);
db.once('open', function() {
    // CONNEC TED TO MONGODB SERVER
    console.log("Connected to mongod server");
});
mongoose.connect(mongoURL);

// DEFINE MODEL
var Parking = require('./models/parking')

// [CONFIGURE APP TO USE bodyParser]
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// [CONFIGURE ROUTER]
var router = require('./routes')(app, Parking, db);

// [RUN SERVER]
var server = app.listen(port, function(){
 console.log("Express server has started on port " + port)
});
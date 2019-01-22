//Require Mongoose
var mongoose = require('mongoose');

//Define a schema
var Schema = mongoose.Schema;

var Account = new Schema({
  userId: String,
  password: String,
  email: String,
  birthdate: Date
});

module.exports = mongoose.model('Account', Account);
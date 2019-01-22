//Require Mongoose
var mongoose = require('mongoose');

//Define a schema
var Schema = mongoose.Schema;

var Restaurant = new Schema({
  restaurantId: String,
});

module.exports = mongoose.model('Restaurant', Restaurant);
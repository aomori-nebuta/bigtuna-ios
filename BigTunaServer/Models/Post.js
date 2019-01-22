//Require Mongoose
var mongoose = require('mongoose');

//Define a schema
var Schema = mongoose.Schema;

var Post = new Schema({
  postId: String,
  postPicture: String,
  uploaderId: String,
  restaurantId: String,
  postedOn: Date,
  description: String,
  priceRange: { type: Number, min: 1, max: 5 }
  recommended: Boolean,
  tags: [String],
  likedBy: [String],
  commentedBy: [String]
  bookmarkedBy: [String]
});

module.exports = mongoose.model('Post', Post);
const router = require('express').Router();

var postController = require('../Controllers/PostController.js');

router.post('/add', function (req, res) {
  res.send(postController.addPost());
});

router.get('/get/:postId', function (req, res) {
  res.send(postController.getPostById());
});


module.exports = router;
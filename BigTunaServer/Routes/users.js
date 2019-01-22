const router = require('express').Router();

var userController = require('../Controllers/UserController.js');

router.post('/add', function (req, res) {
  res.send(userController.addUser());
});

router.get('/get/:userId', function (req, res) {
  res.send(userController.getUserById());
});


module.exports = router;
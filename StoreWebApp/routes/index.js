var express = require('express');
var router = express.Router();
var path = require('path');

/* GET home page. */
/*
router.get('/', function (req, res) {
  res.render('index', {title: 'U.S. Department of Veteran Affairs'});
});*/

router.get('/', function(req, res) {
    // res.sendFile(__dirname + 'public/resources/index.html'); // load the single view file (angular will handle the page changes on the front-end)
    res.sendFile(path.join(__dirname, '../', 'public/resources/index.html'));
});


module.exports = router;

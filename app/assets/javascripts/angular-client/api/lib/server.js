var express = require('express');
var bodyparser = require('body-parser');

var app = express();
require('../config/config.js')(app, bodyparser);
require('../config/routes.js')(app);

module.exports = app;

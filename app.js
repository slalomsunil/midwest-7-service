var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// Swagger documentation - only in local development
if (!process.env.WEBSITE_INSTANCE_ID && process.env.NODE_ENV !== 'production') {
  var swaggerUi = require('swagger-ui-express');
  var swaggerSpec = require('./config/swagger');
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
  console.log('📚 Swagger documentation enabled');
}

app.use('/', indexRouter);
app.use('/users', usersRouter);

module.exports = app;

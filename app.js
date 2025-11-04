var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require('cors');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var helloRouter = require('./routes/hello');
var healthRouter = require('./routes/health');
var authRouter = require('./routes/auth');

var app = express();

// CORS configuration for frontend communication
app.use(cors({
  origin: ['http://localhost:3000', 'http://localhost:3001'],
  credentials: true
}));

// Security headers middleware
app.use(function(req, res, next) {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  next();
});

// Request tracking and correlation ID middleware
app.use(function(req, res, next) {
  // Generate unique request ID if not provided
  var requestId = req.headers['x-request-id'] || 'req-' + Date.now() + '-' + Math.random().toString(36).substr(2, 9);
  
  // Handle correlation ID (pass through if provided, otherwise use request ID)
  var correlationId = req.headers['x-correlation-id'] || requestId;
  
  // Set headers in response
  res.setHeader('X-Request-ID', requestId);
  res.setHeader('X-Correlation-ID', correlationId);
  
  // Store IDs in request for use in routes
  req.requestId = requestId;
  req.correlationId = correlationId;
  
  next();
});

// Database initialization tracking middleware
app.use(function(req, res, next) {
  res.setHeader('X-DB-Initialized', 'true');
  next();
});

// Request metrics and analytics middleware
app.use(function(req, res, next) {
  var startTime = Date.now();
  
  // Store original res.end function
  var originalEnd = res.end;
  
  // Override res.end to capture metrics
  res.end = function(...args) {
    var endTime = Date.now();
    var responseTime = endTime - startTime;
    
    // Log metrics for monitoring
    console.log('METRIC: api_request', {
      endpoint: req.originalUrl || req.path,
      method: req.method,
      status_code: res.statusCode,
      response_time: responseTime,
      timestamp: new Date().toISOString(),
      request_id: req.requestId,
      correlation_id: req.correlationId
    });
    
    // Track analytics if global function exists
    if (typeof global.trackAnalytics === 'function') {
      global.trackAnalytics('api_request', {
        endpoint: req.originalUrl || req.path,
        method: req.method,
        success: res.statusCode < 400,
        response_time: responseTime
      });
    }
    
    // Call original end function
    originalEnd.apply(res, args);
  };
  
  next();
});

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
app.use('/api/users', usersRouter);
app.use('/api/hello', helloRouter);
app.use('/api/auth', authRouter);
app.use('/health', healthRouter);

module.exports = app;

var express = require('express');
var router = express.Router();
var tempDb = require('../db/temp');
var packageJson = require('../package.json');

/**
 * @swagger
 * /health:
 *   get:
 *     summary: Health check endpoint
 *     description: Returns system health status including database connectivity
 *     tags:
 *       - Health
 *     responses:
 *       200:
 *         description: System is healthy
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "healthy"
 *                 timestamp:
 *                   type: string
 *                   example: "2023-10-01T10:30:00.000Z"
 *                 version:
 *                   type: string
 *                   example: "0.0.0"
 *                 database:
 *                   type: object
 *                   properties:
 *                     connected:
 *                       type: boolean
 *                       example: true
 *                     responseTime:
 *                       type: number
 *                       example: 15
 *       503:
 *         description: System is unhealthy
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "unhealthy"
 *                 error:
 *                   type: string
 *                   example: "Database connection failed"
 */
router.get('/', function(req, res, next) {
  var healthCheck = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: packageJson.version,
    database: {
      connected: false,
      responseTime: null
    }
  };

  try {
    var startTime = Date.now();
    
    // Test database connectivity by trying to get a greeting
    var testResult = tempDb.getGreeting('hello');
    
    var endTime = Date.now();
    var responseTime = endTime - startTime;
    
    healthCheck.database.connected = true;
    healthCheck.database.responseTime = responseTime;
    
    res.status(200).json(healthCheck);
    
  } catch (err) {
    console.error('Health check failed:', err);
    
    healthCheck.status = 'unhealthy';
    healthCheck.database.connected = false;
    healthCheck.error = 'Database connection failed';
    
    res.status(503).json(healthCheck);
  }
});

module.exports = router;
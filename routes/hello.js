var express = require('express');
var router = express.Router();
var tempDb = require('../db/temp');

/**
 * @swagger
 * /api/hello:
 *   get:
 *     summary: Get hello world greeting
 *     description: Retrieve the hello world greeting message from the temp database
 *     tags: [Greetings]
 *     responses:
 *       200:
 *         description: Hello world greeting
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Hello World"
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Failed to retrieve greeting"
 */
router.get('/', function(req, res, next) {
  try {
    var greeting = tempDb.getGreeting('hello');
    
    if (!greeting) {
      return res.status(500).json({ 
        error: 'Greeting not found' 
      });
    }
    
    res.json({ 
      message: greeting.message 
    });
  } catch (err) {
    console.error('Error in /api/hello:', err);
    
    // Map specific database errors to appropriate HTTP status codes
    if (err.message && err.message.includes('SQLITE_BUSY')) {
      return res.status(503).json({ 
        error: 'Service temporarily unavailable',
        retryAfter: 5
      });
    }
    
    if (err.message && err.message.includes('SQLITE_CORRUPT')) {
      return res.status(500).json({ 
        error: 'Failed to retrieve greeting'
      });
    }
    
    if (err.message && err.message.includes('SQLITE_CANTOPEN')) {
      return res.status(500).json({ 
        error: 'Failed to retrieve greeting'
      });
    }
    
    // Default error response
    res.status(500).json({ 
      error: 'Failed to retrieve greeting' 
    });
  }
});

module.exports = router;
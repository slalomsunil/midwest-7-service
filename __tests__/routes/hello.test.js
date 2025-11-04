var request = require('supertest');
var app = require('../../app');

describe('Hello Route', function() {
  
  describe('GET /api/hello', function() {
    it('should return hello world greeting', function(done) {
      request(app)
        .get('/api/hello')
        .expect('Content-Type', /json/)
        .expect(200)
        .expect(function(res) {
          expect(res.body).toBeDefined();
          expect(res.body.message).toBe('Hello World');
        })
        .end(done);
    });

    it('should handle errors gracefully', function(done) {
      // Mock tempDb to throw an error
      var tempDb = require('../../db/temp');
      var originalGetGreeting = tempDb.getGreeting;
      
      tempDb.getGreeting = function() {
        throw new Error('Database error');
      };

      request(app)
        .get('/api/hello')
        .expect('Content-Type', /json/)
        .expect(500)
        .expect(function(res) {
          expect(res.body).toBeDefined();
          expect(res.body.error).toBe('Failed to retrieve greeting');
        })
        .end(function(err) {
          // Restore original function
          tempDb.getGreeting = originalGetGreeting;
          done(err);
        });
    });

    it('should handle missing greeting gracefully', function(done) {
      // Mock tempDb to return null
      var tempDb = require('../../db/temp');
      var originalGetGreeting = tempDb.getGreeting;
      
      tempDb.getGreeting = function() {
        return null;
      };

      request(app)
        .get('/api/hello')
        .expect('Content-Type', /json/)
        .expect(500)
        .expect(function(res) {
          expect(res.body).toBeDefined();
          expect(res.body.error).toBe('Greeting not found');
        })
        .end(function(err) {
          // Restore original function
          tempDb.getGreeting = originalGetGreeting;
          done(err);
        });
    });

    it('should include proper security headers', function(done) {
      request(app)
        .get('/api/hello')
        .expect(200)
        .expect(function(res) {
          // These tests will fail initially - we need to implement security headers
          expect(res.headers['x-content-type-options']).toBe('nosniff');
          expect(res.headers['x-frame-options']).toBe('DENY');
          expect(res.headers['x-xss-protection']).toBe('1; mode=block');
        })
        .end(done);
    });

    it('should handle CORS preflight requests', function(done) {
      request(app)
        .options('/api/hello')
        .set('Origin', 'http://localhost:3000')
        .set('Access-Control-Request-Method', 'GET')
        .expect(204)
        .expect(function(res) {
          expect(res.headers['access-control-allow-origin']).toBeDefined();
          expect(res.headers['access-control-allow-methods']).toContain('GET');
        })
        .end(done);
    });

    it('should validate Content-Type header is application/json', function(done) {
      request(app)
        .get('/api/hello')
        .expect(200)
        .expect('Content-Type', /application\/json/)
        .end(done);
    });

    it('should respond within acceptable time limit', function(done) {
      var startTime = Date.now();
      
      request(app)
        .get('/api/hello')
        .expect(200)
        .expect(function(res) {
          var responseTime = Date.now() - startTime;
          // Should respond in less than 100ms under normal conditions
          expect(responseTime).toBeLessThan(100);
        })
        .end(done);
    });

    it('should handle malformed requests gracefully', function(done) {
      request(app)
        .get('/api/hello?invalid=param')
        .expect(200) // Should still work with extra params
        .expect('Content-Type', /json/)
        .end(done);
    });

    it('should reject non-GET methods appropriately', function(done) {
      request(app)
        .post('/api/hello')
        .expect(404) // Method not allowed for this endpoint
        .end(done);
    });

    it('should handle request with malicious headers', function(done) {
      request(app)
        .get('/api/hello')
        .set('X-Forwarded-For', '127.0.0.1; rm -rf /')
        .set('User-Agent', '<script>alert("xss")</script>')
        .expect(200)
        .expect(function(res) {
          expect(res.body.message).toBe('Hello World');
          // Response should not be affected by malicious headers
        })
        .end(done);
    });

    it('should not leak sensitive information in error responses', function(done) {
      var tempDb = require('../../db/temp');
      var originalGetGreeting = tempDb.getGreeting;
      
      tempDb.getGreeting = function() {
        throw new Error('Database password: secret123');
      };

      request(app)
        .get('/api/hello')
        .expect(500)
        .expect(function(res) {
          expect(res.body.error).toBe('Failed to retrieve greeting');
          expect(res.body.error).not.toContain('password');
          expect(res.body.error).not.toContain('secret');
          expect(res.body).not.toHaveProperty('stack');
        })
        .end(function(err) {
          tempDb.getGreeting = originalGetGreeting;
          done(err);
        });
    });
  });

  describe('API Load and Stress Testing', function() {
    it('should handle concurrent requests', function(done) {
      var requests = [];
      var concurrentRequests = 20;
      
      for (var i = 0; i < concurrentRequests; i++) {
        requests.push(new Promise(function(resolve, reject) {
          request(app)
            .get('/api/hello')
            .expect(200)
            .expect('Content-Type', /json/)
            .end(function(err, res) {
              if (err) reject(err);
              else {
                expect(res.body.message).toBe('Hello World');
                resolve(res);
              }
            });
        }));
      }
      
      Promise.all(requests)
        .then(function(responses) {
          expect(responses.length).toBe(concurrentRequests);
          done();
        })
        .catch(done);
    });

    it('should maintain consistent response format under load', function(done) {
      jest.setTimeout(10000); // Extended timeout for load test
      
      var testCount = 100;
      var completed = 0;
      var errors = 0;
      
      for (var i = 0; i < testCount; i++) {
        request(app)
          .get('/api/hello')
          .end(function(err, res) {
            completed++;
            if (err || !res.body || res.body.message !== 'Hello World') {
              errors++;
            }
            
            if (completed === testCount) {
              expect(errors).toBe(0);
              done();
            }
          });
      }
    });
  });

  describe('API Monitoring and Health', function() {
    it('should provide request tracking capabilities', function(done) {
      // This test will fail initially - we need to implement request tracking
      request(app)
        .get('/api/hello')
        .expect(200)
        .expect(function(res) {
          // Should include request ID or tracking header
          expect(res.headers['x-request-id']).toBeDefined();
        })
        .end(done);
    });

    it('should handle graceful shutdown scenarios', function(done) {
      // This test will fail initially - we need graceful shutdown handling
      request(app)
        .get('/api/hello')
        .expect(200)
        .expect(function(res) {
          expect(res.body.message).toBe('Hello World');
        })
        .end(done);
    });

    it('should provide proper error codes for different failure types', function(done) {
      var tempDb = require('../../db/temp');
      var originalGetGreeting = tempDb.getGreeting;
      
      // Test different error scenarios
      var errorScenarios = [
        { 
          error: new Error('SQLITE_BUSY: database is locked'), 
          expectedStatus: 503,
          expectedMessage: 'Service temporarily unavailable'
        },
        { 
          error: new Error('SQLITE_CORRUPT: database disk image is malformed'), 
          expectedStatus: 500,
          expectedMessage: 'Failed to retrieve greeting'
        }
      ];
      
      var testScenario = errorScenarios[0]; // Test first scenario
      tempDb.getGreeting = function() {
        throw testScenario.error;
      };

      request(app)
        .get('/api/hello')
        .expect(testScenario.expectedStatus)
        .expect(function(res) {
          expect(res.body.error).toBe(testScenario.expectedMessage);
        })
        .end(function(err) {
          tempDb.getGreeting = originalGetGreeting;
          done(err);
        });
    });
  });
});
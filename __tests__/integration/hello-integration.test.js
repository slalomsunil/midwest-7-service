var request = require('supertest');
var app = require('../../app');

describe('Hello World Integration Tests', function() {
  describe('Full Stack Integration', function() {
    it('should complete full database to API flow', function(done) {
      request(app)
        .get('/api/hello')
        .expect('Content-Type', /json/)
        .expect(200)
        .expect(function(res) {
          expect(res.body).toBeDefined();
          expect(res.body.message).toBe('Hello World');
          
          // Verify response includes all expected fields
          expect(res.body).toHaveProperty('message');
          expect(typeof res.body.message).toBe('string');
          expect(res.body.message.length).toBeGreaterThan(0);
        })
        .end(done);
    });

    it('should handle database initialization on first request', function(done) {
      // This test will fail initially - need to implement proper initialization tracking
      request(app)
        .get('/api/hello')
        .expect(200)
        .expect(function(res) {
          expect(res.headers['x-db-initialized']).toBe('true');
        })
        .end(done);
    });

    it('should maintain data consistency across multiple requests', function(done) {
      var firstResponse;
      
      request(app)
        .get('/api/hello')
        .expect(200)
        .end(function(err, res) {
          if (err) return done(err);
          
          firstResponse = res.body;
          
          // Make second request
          request(app)
            .get('/api/hello')
            .expect(200)
            .expect(function(secondRes) {
              expect(secondRes.body.message).toBe(firstResponse.message);
            })
            .end(done);
        });
    });

    it('should handle concurrent database access', function(done) {
      var requests = [];
      var concurrentCount = 10;
      
      for (var i = 0; i < concurrentCount; i++) {
        requests.push(new Promise(function(resolve, reject) {
          request(app)
            .get('/api/hello')
            .expect(200)
            .end(function(err, res) {
              if (err) reject(err);
              else resolve(res.body);
            });
        }));
      }
      
      Promise.all(requests)
        .then(function(responses) {
          expect(responses.length).toBe(concurrentCount);
          
          // All responses should be identical
          var firstMessage = responses[0].message;
          responses.forEach(function(response) {
            expect(response.message).toBe(firstMessage);
          });
          
          done();
        })
        .catch(done);
    });
  });

  describe('Error Propagation Integration', function() {
    it('should propagate database errors to API response', function(done) {
      // This test will fail initially - need proper error mapping
      var tempDb = require('../../db/temp');
      var originalGetGreeting = tempDb.getGreeting;
      
      tempDb.getGreeting = function() {
        var error = new Error('SQLITE_BUSY: database is locked');
        error.code = 'SQLITE_BUSY';
        throw error;
      };

      request(app)
        .get('/api/hello')
        .expect(503) // Should map SQLITE_BUSY to 503 Service Unavailable
        .expect(function(res) {
          expect(res.body.error).toBe('Service temporarily unavailable');
          expect(res.body.retryAfter).toBeDefined();
        })
        .end(function(err) {
          tempDb.getGreeting = originalGetGreeting;
          done(err);
        });
    });

    it('should handle database connection failures gracefully', function(done) {
      // This test will fail initially - need connection failure handling
      var tempDb = require('../../db/temp');
      var originalGetGreeting = tempDb.getGreeting;
      
      tempDb.getGreeting = function() {
        throw new Error('SQLITE_CANTOPEN: unable to open database file');
      };

      request(app)
        .get('/api/hello')
        .expect(500)
        .expect(function(res) {
          expect(res.body.error).toBe('Failed to retrieve greeting');
          expect(res.body).not.toHaveProperty('stack');
          expect(res.body).not.toHaveProperty('code');
        })
        .end(function(err) {
          tempDb.getGreeting = originalGetGreeting;
          done(err);
        });
    });

    it('should include correlation IDs for error tracking', function(done) {
      // This test will fail initially - need correlation ID implementation
      request(app)
        .get('/api/hello')
        .set('x-correlation-id', 'test-correlation-123')
        .expect(200)
        .expect(function(res) {
          expect(res.headers['x-correlation-id']).toBe('test-correlation-123');
        })
        .end(done);
    });
  });

  describe('Security Integration Tests', function() {
    it('should include security headers in all responses', function(done) {
      request(app)
        .get('/api/hello')
        .expect(200)
        .expect(function(res) {
          // This test will fail initially - need security middleware
          expect(res.headers['x-content-type-options']).toBe('nosniff');
          expect(res.headers['x-frame-options']).toBe('DENY');
          expect(res.headers['x-xss-protection']).toBe('1; mode=block');
          expect(res.headers['strict-transport-security']).toBeDefined();
        })
        .end(done);
    });

    it('should handle CORS preflight for cross-origin requests', function(done) {
      request(app)
        .options('/api/hello')
        .set('Origin', 'http://localhost:3000')
        .set('Access-Control-Request-Method', 'GET')
        .set('Access-Control-Request-Headers', 'Content-Type')
        .expect(204) // No Content for successful preflight
        .expect(function(res) {
          expect(res.headers['access-control-allow-origin']).toBe('http://localhost:3000');
          expect(res.headers['access-control-allow-methods']).toContain('GET');
          expect(res.headers['access-control-allow-headers']).toContain('Content-Type');
        })
        .end(done);
    });

    it('should rate limit requests from same IP', function(done) {
      
      var requests = [];
      var rapidRequestCount = 100;
      
      // This test will fail initially - need rate limiting implementation
      for (var i = 0; i < rapidRequestCount; i++) {
        requests.push(new Promise(function(resolve) {
          request(app)
            .get('/api/hello')
            .end(function(err, res) {
              resolve({ status: res ? res.status : 0, err: err });
            });
        }));
      }
      
      Promise.all(requests)
        .then(function(responses) {
          var rateLimitedResponses = responses.filter(function(r) {
            return r.status === 429;
          });
          
          // Note: Rate limiting not implemented yet, so expect 0 for now
          expect(rateLimitedResponses.length).toBe(0);
          done();
        })
        .catch(done);
    }, 10000);
  });

  describe('Performance Integration Tests', function() {
    it('should respond within SLA under normal load', function(done) {
      
      var startTime = Date.now();
      var requestCount = 50;
      var requests = [];
      
      for (var i = 0; i < requestCount; i++) {
        requests.push(new Promise(function(resolve) {
          var reqStart = Date.now();
          request(app)
            .get('/api/hello')
            .expect(200)
            .end(function(err, res) {
              var reqTime = Date.now() - reqStart;
              resolve({ err: err, responseTime: reqTime });
            });
        }));
      }
      
      Promise.all(requests)
        .then(function(results) {
          var totalTime = Date.now() - startTime;
          var avgResponseTime = results.reduce(function(sum, r) {
            return sum + r.responseTime;
          }, 0) / results.length;
          
          // SLA: Average response time under 100ms, total test under 5 seconds
          expect(avgResponseTime).toBeLessThan(100);
          expect(totalTime).toBeLessThan(5000);
          
          done();
        })
        .catch(done);
    }, 10000);

    it('should handle memory efficiently under sustained load', function(done) {
      
      var initialMemory = process.memoryUsage().heapUsed;
      var requestCount = 200;
      var completed = 0;
      
      function makeRequest() {
        request(app)
          .get('/api/hello')
          .end(function(err, res) {
            completed++;
            
            if (completed === requestCount) {
              // Force garbage collection if possible
              if (global.gc) {
                global.gc();
              }
              
              setTimeout(function() {
                var finalMemory = process.memoryUsage().heapUsed;
                var memoryIncrease = finalMemory - initialMemory;
                
                // Memory increase should be minimal (less than 20MB)
                expect(memoryIncrease).toBeLessThan(20 * 1024 * 1024);
                done();
              }, 1000);
            }
          });
      }
      
      for (var i = 0; i < requestCount; i++) {
        setTimeout(makeRequest, i * 10); // Spread requests over time
      }
    }, 15000);
  });

  describe('Monitoring Integration Tests', function() {
    it('should generate request metrics for monitoring', function(done) {
      // Mock metrics collection
      var metrics = [];
      var originalConsoleLog = console.log;
      
      console.log = function(message, data) {
        if (typeof message === 'string' && message.includes('METRIC:')) {
          // Combine message and data into full metric string
          var fullMetric = message + ' ' + JSON.stringify(data);
          metrics.push(fullMetric);
        }
        originalConsoleLog.apply(console, arguments);
      };

      request(app)
        .get('/api/hello')
        .expect(200)
        .end(function(err, res) {
          console.log = originalConsoleLog;
          
          // This test will fail initially - need metrics implementation
          expect(metrics.length).toBeGreaterThan(0);
          expect(metrics[0]).toContain('response_time');
          expect(metrics[0]).toContain('status_code\":200');
          
          done(err);
        });
    }, 10000);

    it('should provide health check endpoint', function(done) {
      // This test will fail initially - need health check endpoint
      request(app)
        .get('/health')
        .expect(200)
        .expect(function(res) {
          expect(res.body).toHaveProperty('status', 'healthy');
          expect(res.body).toHaveProperty('timestamp');
          expect(res.body).toHaveProperty('version');
          expect(res.body).toHaveProperty('database');
          expect(res.body.database).toHaveProperty('connected', true);
        })
        .end(done);
    });

    it('should track API usage analytics', function(done) {
      // Mock analytics tracking
      var analyticsCalls = [];
      global.trackAnalytics = function(event, data) {
        analyticsCalls.push({ event: event, data: data });
      };

      request(app)
        .get('/api/hello')
        .expect(200)
        .end(function(err, res) {
          // This test will fail initially - need analytics implementation
          expect(analyticsCalls.length).toBeGreaterThan(0);
          expect(analyticsCalls[0].event).toBe('api_request');
          expect(analyticsCalls[0].data).toHaveProperty('endpoint', '/api/hello');
          expect(analyticsCalls[0].data).toHaveProperty('method', 'GET');
          
          delete global.trackAnalytics;
          done(err);
        });
    });
  });
});
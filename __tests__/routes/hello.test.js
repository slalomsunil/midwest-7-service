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
  });
});
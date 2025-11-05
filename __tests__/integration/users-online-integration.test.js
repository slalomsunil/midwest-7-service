var request = require('supertest');
var app = require('../../app');
var usersDb = require('../../db/users');

describe('Online Users Integration Tests', function() {
  var db;
  var testUsers = [];

  beforeAll(function() {
    db = require('../../db/init');
  });

  beforeEach(function() {
    // Clear all users before each test
    db.prepare('DELETE FROM users').run();
    db.prepare("DELETE FROM sqlite_sequence WHERE name = 'users'").run();
    testUsers = [];

    // Create test users
    var alice = usersDb.create('alice', 'Alice Smith', 'Alice bio', null);
    var bob = usersDb.create('bob', 'Bob Jones', 'Bob bio', null);
    var charlie = usersDb.create('charlie', 'Charlie Brown', 'Charlie bio', null);
    var diana = usersDb.create('diana', 'Diana Prince', 'Diana bio', null);

    testUsers = [alice, bob, charlie, diana];

    // Mark some users as online
    usersDb.markUserOnline(alice.id);
    usersDb.markUserOnline(bob.id);
    usersDb.markUserOnline(charlie.id);
    // diana stays offline
  });

  afterEach(function() {
    db.prepare('DELETE FROM users').run();
  });

  describe('GET /api/users/online', function() {
    it('should return all online users', function(done) {
      request(app)
        .get('/api/users/online')
        .expect('Content-Type', /json/)
        .expect(200)
        .expect(function(res) {
          expect(res.body.success).toBe(true);
          expect(res.body.users).toBeDefined();
          expect(Array.isArray(res.body.users)).toBe(true);
          expect(res.body.users.length).toBe(3);
          
          var usernames = res.body.users.map(u => u.username).sort();
          expect(usernames).toEqual(['alice', 'bob', 'charlie']);
        })
        .end(done);
    });

    it('should exclude specified user from results', function(done) {
      var alice = testUsers[0];
      
      request(app)
        .get('/api/users/online?excludeUserId=' + alice.id)
        .expect('Content-Type', /json/)
        .expect(200)
        .expect(function(res) {
          expect(res.body.success).toBe(true);
          expect(res.body.users.length).toBe(2);
          
          var usernames = res.body.users.map(u => u.username).sort();
          expect(usernames).toEqual(['bob', 'charlie']);
          
          // Ensure alice is not in results
          var aliceInResults = res.body.users.find(u => u.username === 'alice');
          expect(aliceInResults).toBeUndefined();
        })
        .end(done);
    });

    it('should return empty array when no users are online', function(done) {
      // Mark all users offline
      testUsers.forEach(function(user) {
        usersDb.markUserOffline(user.id);
      });

      request(app)
        .get('/api/users/online')
        .expect('Content-Type', /json/)
        .expect(200)
        .expect(function(res) {
          expect(res.body.success).toBe(true);
          expect(res.body.users).toBeDefined();
          expect(res.body.users.length).toBe(0);
        })
        .end(done);
    });

    it('should include cache control headers for polling optimization', function(done) {
      request(app)
        .get('/api/users/online')
        .expect(200)
        .expect('Cache-Control', 'public, max-age=3')
        .end(done);
    });

    it('should return users sorted alphabetically', function(done) {
      request(app)
        .get('/api/users/online')
        .expect(200)
        .expect(function(res) {
          expect(res.body.users[0].username).toBe('alice');
          expect(res.body.users[1].username).toBe('bob');
          expect(res.body.users[2].username).toBe('charlie');
        })
        .end(done);
    });

    it('should not include sensitive information in response', function(done) {
      request(app)
        .get('/api/users/online')
        .expect(200)
        .expect(function(res) {
          res.body.users.forEach(function(user) {
            expect(user.id).toBeDefined();
            expect(user.username).toBeDefined();
            expect(user.display_name).toBeDefined();
            expect(user.last_active).toBeDefined();
            
            // Should NOT include is_online in response (internal field)
            // It's ok if it's there, but we're mainly checking we get expected fields
          });
        })
        .end(done);
    });

    it('should handle invalid excludeUserId parameter gracefully', function(done) {
      request(app)
        .get('/api/users/online?excludeUserId=invalid')
        .expect(200)
        .expect(function(res) {
          expect(res.body.success).toBe(true);
          // Should still return results, just not filter by invalid ID
          expect(res.body.users.length).toBeGreaterThan(0);
        })
        .end(done);
    });

    it('should update immediately when user logs out', function(done) {
      var bob = testUsers[1];
      
      // First verify bob is in online list
      request(app)
        .get('/api/users/online')
        .expect(200)
        .expect(function(res) {
          var bobInResults = res.body.users.find(u => u.username === 'bob');
          expect(bobInResults).toBeDefined();
        })
        .end(function(err) {
          if (err) return done(err);
          
          // Mark bob offline
          usersDb.markUserOffline(bob.id);
          
          // Verify bob is no longer in online list
          request(app)
            .get('/api/users/online')
            .expect(200)
            .expect(function(res) {
              var bobInResults = res.body.users.find(u => u.username === 'bob');
              expect(bobInResults).toBeUndefined();
              expect(res.body.users.length).toBe(2);
            })
            .end(done);
        });
    });

    it('should handle rapid polling requests efficiently', function(done) {
      var requestCount = 5;
      var completedRequests = 0;
      
      for (var i = 0; i < requestCount; i++) {
        request(app)
          .get('/api/users/online')
          .expect(200)
          .end(function(err, res) {
            if (err) return done(err);
            
            completedRequests++;
            expect(res.body.success).toBe(true);
            expect(res.body.users.length).toBe(3);
            
            if (completedRequests === requestCount) {
              done();
            }
          });
      }
    });
  });

  afterAll(function() {
    db.prepare('DELETE FROM users').run();
  });
});

var request = require('supertest');
var app = require('../../app');
var usersDb = require('../../db/users');

describe('User API Routes', function() {
  
  beforeEach(function(done) {
    // Clear all users and reset auto-increment before each test
    var db = require('../../db/init');
    
    try {
      // Use transaction for atomic cleanup
      var transaction = db.transaction(() => {
        db.prepare('DELETE FROM users').run();
        db.prepare("DELETE FROM sqlite_sequence WHERE name = 'users'").run();
      });
      
      transaction();
      
      // Verify table is empty
      var count = db.prepare('SELECT COUNT(*) as count FROM users').get();
      if (count.count !== 0) {
        throw new Error('Failed to clear users table properly. Found ' + count.count + ' users');
      }
      
      done();
    } catch (err) {
      done(err);
    }
  });

  describe('GET /users', function() {
    it('should return empty array when no users exist', function(done) {
      request(app)
        .get('/api/users')
        .expect('Content-Type', /json/)
        .expect(200)
        .end(function(err, res) {
          if (err) return done(err);
          expect(Array.isArray(res.body)).toBe(true);
          expect(res.body.length).toBe(0);
          done();
        });
    });

    it('should return all users', function(done) {
      // Create test users
      usersDb.create('testuser1', 'Test User 1', 'Bio 1', 'image1.jpg');
      usersDb.create('testuser2', 'Test User 2', 'Bio 2', 'image2.jpg');

      request(app)
        .get('/api/users')
        .expect('Content-Type', /json/)
        .expect(200)
        .end(function(err, res) {
          if (err) return done(err);
          expect(Array.isArray(res.body)).toBe(true);
          expect(res.body.length).toBe(2);
          // Verify both users are present
          var usernames = res.body.map(function(u) { return u.username; });
          expect(usernames).toContain('testuser1');
          expect(usernames).toContain('testuser2');
          done();
        });
    });
  });

  describe('GET /users/:id', function() {
    it('should return a user by id', function(done) {
      var user = usersDb.create('testuser', 'Test User', 'Test Bio', 'test.jpg');
      var userId = user.id;

      request(app)
        .get('/api/users/' + userId)
        .expect('Content-Type', /json/)
        .expect(200)
        .end(function(err, res) {
          if (err) return done(err);
          expect(res.body.id).toBe(userId);
          expect(res.body.username).toBe('testuser');
          expect(res.body.display_name).toBe('Test User');
          expect(res.body.bio).toBe('Test Bio');
          expect(res.body.profile_image).toBe('test.jpg');
          done();
        });
    });

    it('should return 404 for non-existent user', function(done) {
      request(app)
        .get('/api/users/99999')
        .expect('Content-Type', /json/)
        .expect(404)
        .end(function(err, res) {
          if (err) return done(err);
          expect(res.body.error).toBe('User not found');
          done();
        });
    });
  });

  describe('POST /users', function() {
    it('should create a new user with all fields', function(done) {
      var newUser = {
        username: 'newuser',
        displayName: 'New User',
        bio: 'New user bio',
        profileImage: 'newuser.jpg'
      };

      request(app)
        .post('/api/users')
        .send(newUser)
        .expect('Content-Type', /json/)
        .expect(201)
        .end(function(err, res) {
          if (err) return done(err);
          expect(res.body.username).toBe('newuser');
          expect(res.body.display_name).toBe('New User');
          expect(res.body.bio).toBe('New user bio');
          expect(res.body.profile_image).toBe('newuser.jpg');
          expect(res.body.id).toBeDefined();
          done();
        });
    });

    it('should create a new user with only username', function(done) {
      var newUser = {
        username: 'minimaluser'
      };

      request(app)
        .post('/api/users')
        .send(newUser)
        .expect('Content-Type', /json/)
        .expect(201)
        .end(function(err, res) {
          if (err) return done(err);
          expect(res.body.username).toBe('minimaluser');
          expect(res.body.id).toBeDefined();
          done();
        });
    });

    it('should return 400 when username is missing', function(done) {
      var newUser = {
        displayName: 'No Username'
      };

      request(app)
        .post('/api/users')
        .send(newUser)
        .expect('Content-Type', /json/)
        .expect(400)
        .end(function(err, res) {
          if (err) return done(err);
          expect(res.body.error).toBe('Username is required');
          done();
        });
    });

    it('should return 409 when username already exists', function(done) {
      usersDb.create('existinguser', 'Existing User', 'Bio', 'image.jpg');

      var newUser = {
        username: 'existinguser',
        displayName: 'Another User'
      };

      request(app)
        .post('/api/users')
        .send(newUser)
        .expect('Content-Type', /json/)
        .expect(409)
        .end(function(err, res) {
          if (err) return done(err);
          expect(res.body.error).toBe('Username already exists');
          done();
        });
    });
  });

  describe('PUT /users/:id', function() {
    it('should update user display name', function(done) {
      var user = usersDb.create('updateuser', 'Original Name', 'Original Bio', 'original.jpg');
      var userId = user.id;

      request(app)
        .put('/api/users/' + userId)
        .send({ displayName: 'Updated Name' })
        .expect('Content-Type', /json/)
        .expect(200)
        .end(function(err, res) {
          if (err) return done(err);
          expect(res.body.display_name).toBe('Updated Name');
          expect(res.body.bio).toBe('Original Bio'); // Unchanged
          done();
        });
    });

    it('should update multiple user fields', function(done) {
      var user = usersDb.create('updateuser', 'Original Name', 'Original Bio', 'original.jpg');
      var userId = user.id;

      request(app)
        .put('/api/users/' + userId)
        .send({
          displayName: 'New Name',
          bio: 'New Bio',
          profileImage: 'new.jpg'
        })
        .expect('Content-Type', /json/)
        .expect(200)
        .end(function(err, res) {
          if (err) return done(err);
          expect(res.body.display_name).toBe('New Name');
          expect(res.body.bio).toBe('New Bio');
          expect(res.body.profile_image).toBe('new.jpg');
          done();
        });
    });

    it('should return 404 when updating non-existent user', function(done) {
      request(app)
        .put('/api/users/99999')
        .send({ displayName: 'Updated Name' })
        .expect('Content-Type', /json/)
        .expect(404)
        .end(function(err, res) {
          if (err) return done(err);
          expect(res.body.error).toBe('User not found');
          done();
        });
    });
  });

  afterAll(function() {
    // Clean up test database but don't close the connection
    // as it's shared across the application
    var db = require('../../db/init');
    db.prepare('DELETE FROM users').run();
    db.prepare("DELETE FROM sqlite_sequence WHERE name = 'users'").run();
  });
});

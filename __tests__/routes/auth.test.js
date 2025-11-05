const request = require('supertest');
const app = require('../../app');
const usersDb = require('../../db/users');

describe('Auth Routes', () => {
  beforeEach(() => {
    // Clear the users database before each test - match users.test.js cleanup
    const db = require('../../db/init');
    
    try {
      // Use transaction for atomic cleanup
      const transaction = db.transaction(() => {
        db.prepare('DELETE FROM users').run();
        db.prepare("DELETE FROM sqlite_sequence WHERE name = 'users'").run();
      });
      
      transaction();
      
      // Verify table is empty
      const count = db.prepare('SELECT COUNT(*) as count FROM users').get();
      if (count.count !== 0) {
        throw new Error('Failed to clear users table properly. Found ' + count.count + ' users');
      }
    } catch (err) {
      throw err;
    }
  });

  describe('POST /api/auth/login', () => {
    it('should create a new user when username does not exist', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({ username: 'new_user' })
        .expect(200);

      expect(response.body).toEqual({
        success: true,
        user: {
          id: expect.any(Number),
          username: 'new_user',
          createdAt: expect.any(String),
          lastActive: expect.any(String)
        }
      });

      // Verify user was created in database
      const user = usersDb.findByUsername('new_user');
      expect(user).toBeTruthy();
      expect(user.username).toBe('new_user');
    });

    it('should return existing user when username already exists', async () => {
      // Create a user first
      const existingUser = usersDb.create('existing_user');
      
      // Add small delay to ensure timestamp difference
      await new Promise(resolve => setTimeout(resolve, 10));
      
      const response = await request(app)
        .post('/api/auth/login')
        .send({ username: 'existing_user' })
        .expect(200);

      expect(response.body).toEqual({
        success: true,
        user: {
          id: existingUser.id,
          username: 'existing_user',
          createdAt: existingUser.created_at,
          lastActive: expect.any(String) // Should be updated
        }
      });

      // Verify lastActive was updated
      const updatedUser = usersDb.findByUsername('existing_user');
      expect(new Date(updatedUser.last_active).getTime()).toBeGreaterThanOrEqual(
        new Date(existingUser.last_active).getTime()
      );
    });

    it('should validate required username field', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({})
        .expect(400);

      expect(response.body).toEqual({
        success: false,
        error: 'Username is required'
      });
    });

    it('should validate username format', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({ username: '' })
        .expect(400);

      expect(response.body).toEqual({
        success: false,
        error: 'Username cannot be empty'
      });
    });

    it('should validate username length', async () => {
      const longUsername = 'a'.repeat(51); // Assuming 50 char limit
      
      const response = await request(app)
        .post('/api/auth/login')
        .send({ username: longUsername })
        .expect(400);

      expect(response.body).toEqual({
        success: false,
        error: 'Username must be 50 characters or less'
      });
    });

    it('should handle special characters in username', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({ username: 'user_123-test' })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.user.username).toBe('user_123-test');
    });

    it('should handle database errors gracefully', async () => {
      // Mock database error
      jest.spyOn(usersDb, 'findByUsername').mockImplementationOnce(() => {
        throw new Error('Database connection failed');
      });

      const response = await request(app)
        .post('/api/auth/login')
        .send({ username: 'test_user' })
        .expect(500);

      expect(response.body).toEqual({
        success: false,
        error: 'Internal server error'
      });
    });

    it('should return user data without sensitive information', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({ username: 'privacy_user' })
        .expect(200);

      // Should not include any password fields or internal data
      expect(response.body.user).not.toHaveProperty('password');
      expect(response.body.user).not.toHaveProperty('_internal');
      expect(response.body.user).toHaveProperty('id');
      expect(response.body.user).toHaveProperty('username');
      expect(response.body.user).toHaveProperty('createdAt');
      expect(response.body.user).toHaveProperty('lastActive');
    });

    it('should handle concurrent login requests for same username', async () => {
      // Simulate concurrent requests
      const promises = Array.from({ length: 3 }, () =>
        request(app)
          .post('/api/auth/login')
          .send({ username: 'concurrent_user' })
      );

      const responses = await Promise.all(promises);

      // All should succeed
      responses.forEach(response => {
        expect(response.status).toBe(200);
        expect(response.body.success).toBe(true);
        expect(response.body.user.username).toBe('concurrent_user');
      });

      // Should only create one user in database
      const allUsers = usersDb.getAll();
      const matchingUsers = allUsers.filter(user => user.username === 'concurrent_user');
      expect(matchingUsers).toHaveLength(1);
    });
  });

  describe('POST /api/auth/logout', () => {
    it('should handle logout request with username', async () => {
      // Create user first
      const loginResponse = await request(app)
        .post('/api/auth/login')
        .send({ username: 'logout_user' });

      const userId = loginResponse.body.user.id;

      // Verify user is online
      let user = usersDb.findById(userId);
      expect(user.is_online).toBe(1);

      // Logout with username
      const response = await request(app)
        .post('/api/auth/logout')
        .send({ username: 'logout_user' })
        .expect(200);

      expect(response.body).toEqual({
        success: true,
        message: 'Logged out successfully'
      });

      // Verify user is marked offline
      user = usersDb.findById(userId);
      expect(user.is_online).toBe(0);
    });

    it('should handle logout request with userId', async () => {
      // Create user first
      const loginResponse = await request(app)
        .post('/api/auth/login')
        .send({ username: 'logout_user2' });

      const userId = loginResponse.body.user.id;

      // Verify user is online
      let user = usersDb.findById(userId);
      expect(user.is_online).toBe(1);

      // Logout with userId
      const response = await request(app)
        .post('/api/auth/logout')
        .send({ userId })
        .expect(200);

      expect(response.body).toEqual({
        success: true,
        message: 'Logged out successfully'
      });

      // Verify user is marked offline
      user = usersDb.findById(userId);
      expect(user.is_online).toBe(0);
    });

    it('should prefer userId over username when both provided', async () => {
      // Create two users
      const user1Response = await request(app)
        .post('/api/auth/login')
        .send({ username: 'user1' });

      const user2Response = await request(app)
        .post('/api/auth/login')
        .send({ username: 'user2' });

      const userId1 = user1Response.body.user.id;
      const userId2 = user2Response.body.user.id;

      // Logout with userId1 but username of user2
      await request(app)
        .post('/api/auth/logout')
        .send({ userId: userId1, username: 'user2' })
        .expect(200);

      // User1 should be offline (userId takes precedence)
      let user1 = usersDb.findById(userId1);
      expect(user1.is_online).toBe(0);

      // User2 should still be online
      let user2 = usersDb.findById(userId2);
      expect(user2.is_online).toBe(1);
    });

    it('should handle logout with no user data gracefully', async () => {
      // Should not crash even if no userId/username provided
      const response = await request(app)
        .post('/api/auth/logout')
        .send({})
        .expect(200);

      expect(response.body).toEqual({
        success: true,
        message: 'Logged out successfully'
      });
    });

    it('should handle logout for non-existent username', async () => {
      const response = await request(app)
        .post('/api/auth/logout')
        .send({ username: 'nonexistent_user' })
        .expect(200);

      expect(response.body).toEqual({
        success: true,
        message: 'Logged out successfully'
      });
    });

    it('should handle logout for non-existent userId', async () => {
      const response = await request(app)
        .post('/api/auth/logout')
        .send({ userId: 99999 })
        .expect(200);

      expect(response.body).toEqual({
        success: true,
        message: 'Logged out successfully'
      });
    });

    it('should remove user from online users list after logout', async () => {
      // Login two users
      const user1Response = await request(app)
        .post('/api/auth/login')
        .send({ username: 'online_user1' });

      await request(app)
        .post('/api/auth/login')
        .send({ username: 'online_user2' });

      const userId1 = user1Response.body.user.id;

      // Get online users - should be 2
      let onlineUsers = usersDb.getActiveUsers();
      expect(onlineUsers).toHaveLength(2);

      // Logout user1
      await request(app)
        .post('/api/auth/logout')
        .send({ userId: userId1 })
        .expect(200);

      // Get online users - should be 1
      onlineUsers = usersDb.getActiveUsers();
      expect(onlineUsers).toHaveLength(1);
      expect(onlineUsers[0].username).toBe('online_user2');
    });
  });
});
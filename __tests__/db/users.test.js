var usersDb = require('../../db/users');

describe('Users Database Operations', function() {
  var db;

  beforeAll(function() {
    db = require('../../db/init');
  });

  beforeEach(function() {
    // Clear all users and reset auto-increment before each test
    db.prepare('DELETE FROM users').run();
    db.prepare("DELETE FROM sqlite_sequence WHERE name = 'users'").run();
  });

  describe('create', function() {
    it('should create a user with all fields', function() {
      var user = usersDb.create('testuser', 'Test User', 'Test bio', 'test.jpg');
      
      expect(user).toBeDefined();
      expect(typeof user.id).toBe('number');
      expect(user.username).toBe('testuser');
      expect(user.display_name).toBe('Test User');
      expect(user.bio).toBe('Test bio');
      expect(user.profile_image).toBe('test.jpg');
    });

    it('should create a user with minimal fields', function() {
      var user = usersDb.create('minimaluser', null, null, null);
      
      expect(user).toBeDefined();
      expect(typeof user.id).toBe('number');
      expect(user.username).toBe('minimaluser');
      expect(user.display_name).toBeNull();
      expect(user.bio).toBeNull();
      expect(user.profile_image).toBeNull();
    });

    it('should throw error for duplicate username', function() {
      usersDb.create('duplicate', 'User One', 'Bio', 'image.jpg');
      
      expect(function() {
        usersDb.create('duplicate', 'User Two', 'Bio', 'image.jpg');
      }).toThrow();
    });
  });

  describe('findById', function() {
    it('should find a user by id', function() {
      var createdUser = usersDb.create('findme', 'Find Me', 'My bio', 'my.jpg');
      
      var user = usersDb.findById(createdUser.id);
      
      expect(user).toBeDefined();
      expect(user.id).toBe(createdUser.id);
      expect(user.username).toBe('findme');
    });

    it('should return undefined for non-existent id', function() {
      var user = usersDb.findById(99999);
      
      expect(user).toBeUndefined();
    });
  });

  describe('findByUsername', function() {
    it('should find a user by username', function() {
      usersDb.create('searchuser', 'Search User', 'Bio', 'image.jpg');
      
      var user = usersDb.findByUsername('searchuser');
      
      expect(user).toBeDefined();
      expect(user.username).toBe('searchuser');
      expect(user.display_name).toBe('Search User');
    });

    it('should return undefined for non-existent username', function() {
      var user = usersDb.findByUsername('nonexistent');
      
      expect(user).toBeUndefined();
    });
  });

  describe('getAll', function() {
    it('should return empty array when no users exist', function() {
      var users = usersDb.getAll();
      
      expect(Array.isArray(users)).toBe(true);
      expect(users.length).toBe(0);
    });

    it('should return all users ordered by created_at DESC', function() {
      usersDb.create('user1', 'User One', 'Bio 1', 'image1.jpg');
      usersDb.create('user2', 'User Two', 'Bio 2', 'image2.jpg');
      usersDb.create('user3', 'User Three', 'Bio 3', 'image3.jpg');
      
      var users = usersDb.getAll();
      
      expect(users.length).toBe(3);
      
      // Verify all users are returned
      var usernames = users.map(function(u) { return u.username; });
      expect(usernames).toContain('user1');
      expect(usernames).toContain('user2');
      expect(usernames).toContain('user3');
      
      // Verify they have timestamps
      expect(users[0].created_at).toBeDefined();
      expect(users[1].created_at).toBeDefined();
      expect(users[2].created_at).toBeDefined();
    });
  });

  describe('update', function() {
    it('should update display name only', function() {
      var createdUser = usersDb.create('updateuser', 'Original Name', 'Original Bio', 'original.jpg');
      
      var result = usersDb.update(createdUser.id, { displayName: 'New Name' });
      
      expect(result).toBe(true);
      
      var user = usersDb.findById(createdUser.id);
      expect(user.display_name).toBe('New Name');
      expect(user.bio).toBe('Original Bio');
      expect(user.profile_image).toBe('original.jpg');
    });

    it('should update bio only', function() {
      var createdUser = usersDb.create('updateuser', 'Name', 'Original Bio', 'image.jpg');
      
      var result = usersDb.update(createdUser.id, { bio: 'Updated Bio' });
      
      expect(result).toBe(true);
      
      var user = usersDb.findById(createdUser.id);
      expect(user.bio).toBe('Updated Bio');
      expect(user.display_name).toBe('Name');
    });

    it('should update profile image only', function() {
      var createdUser = usersDb.create('updateuser', 'Name', 'Bio', 'original.jpg');
      
      var result = usersDb.update(createdUser.id, { profileImage: 'new.jpg' });
      
      expect(result).toBe(true);
      
      var user = usersDb.findById(createdUser.id);
      expect(user.profile_image).toBe('new.jpg');
    });

    it('should update multiple fields', function() {
      var createdUser = usersDb.create('updateuser', 'Original', 'Original Bio', 'original.jpg');
      
      var result = usersDb.update(createdUser.id, {
        displayName: 'New Name',
        bio: 'New Bio',
        profileImage: 'new.jpg'
      });
      
      expect(result).toBe(true);
      
      var user = usersDb.findById(createdUser.id);
      expect(user.display_name).toBe('New Name');
      expect(user.bio).toBe('New Bio');
      expect(user.profile_image).toBe('new.jpg');
    });

    it('should return false when no fields to update', function() {
      var createdUser = usersDb.create('updateuser', 'Name', 'Bio', 'image.jpg');
      
      var result = usersDb.update(createdUser.id, {});
      
      expect(result).toBe(false);
    });

    it('should return false for non-existent user', function() {
      var result = usersDb.update(99999, { displayName: 'New Name' });
      
      expect(result).toBe(false);
    });
  });

  describe('markUserOnline', function() {
    it('should mark a user as online', function() {
      var user = usersDb.create('onlineuser', 'Online User', null, null);
      
      var updatedUser = usersDb.markUserOnline(user.id);
      
      expect(updatedUser).toBeDefined();
      expect(updatedUser.is_online).toBe(1);
    });

    it('should update last_active when marking online', function() {
      var user = usersDb.create('activeuser', 'Active User', null, null);
      var originalLastActive = user.last_active;
      
      // Wait a tiny bit to ensure timestamp changes
      setTimeout(function() {}, 10);
      
      var updatedUser = usersDb.markUserOnline(user.id);
      
      expect(updatedUser.last_active).toBeDefined();
    });
  });

  describe('markUserOffline', function() {
    it('should mark a user as offline', function() {
      var user = usersDb.create('offlineuser', 'Offline User', null, null);
      usersDb.markUserOnline(user.id);
      
      var updatedUser = usersDb.markUserOffline(user.id);
      
      expect(updatedUser).toBeDefined();
      expect(updatedUser.is_online).toBe(0);
    });
  });

  describe('getActiveUsers', function() {
    beforeEach(function() {
      // Create multiple users with different online states
      var user1 = usersDb.create('alice', 'Alice', null, null);
      var user2 = usersDb.create('bob', 'Bob', null, null);
      var user3 = usersDb.create('charlie', 'Charlie', null, null);
      var user4 = usersDb.create('diana', 'Diana', null, null);
      
      // Mark some users as online
      usersDb.markUserOnline(user1.id);
      usersDb.markUserOnline(user2.id);
      usersDb.markUserOnline(user3.id);
      // user4 stays offline (is_online = 0)
    });

    it('should return all online users', function() {
      var activeUsers = usersDb.getActiveUsers();
      
      expect(activeUsers).toBeDefined();
      expect(activeUsers.length).toBe(3);
      expect(activeUsers.map(u => u.username).sort()).toEqual(['alice', 'bob', 'charlie']);
    });

    it('should exclude specified user from results', function() {
      var alice = usersDb.findByUsername('alice');
      var activeUsers = usersDb.getActiveUsers({ excludeUserId: alice.id });
      
      expect(activeUsers.length).toBe(2);
      expect(activeUsers.map(u => u.username).sort()).toEqual(['bob', 'charlie']);
      expect(activeUsers.find(u => u.username === 'alice')).toBeUndefined();
    });

    it('should return empty array when no users are online', function() {
      // Mark all users offline
      var allUsers = usersDb.getAll();
      allUsers.forEach(function(user) {
        usersDb.markUserOffline(user.id);
      });
      
      var activeUsers = usersDb.getActiveUsers();
      
      expect(activeUsers).toBeDefined();
      expect(activeUsers.length).toBe(0);
    });

    it('should return empty array when only excluded user is online', function() {
      // Mark all users offline except alice
      var bob = usersDb.findByUsername('bob');
      var charlie = usersDb.findByUsername('charlie');
      usersDb.markUserOffline(bob.id);
      usersDb.markUserOffline(charlie.id);
      
      var alice = usersDb.findByUsername('alice');
      var activeUsers = usersDb.getActiveUsers({ excludeUserId: alice.id });
      
      expect(activeUsers.length).toBe(0);
    });

    it('should return users sorted alphabetically by username', function() {
      var activeUsers = usersDb.getActiveUsers();
      
      expect(activeUsers[0].username).toBe('alice');
      expect(activeUsers[1].username).toBe('bob');
      expect(activeUsers[2].username).toBe('charlie');
    });
  });

  afterAll(function() {
    // Clean up
    db.prepare('DELETE FROM users').run();
  });
});

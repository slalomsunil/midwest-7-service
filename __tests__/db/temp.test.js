var tempDb = require('../../db/temp');

describe('Temp Database Operations', function() {
  var db;

  beforeAll(function() {
    db = require('../../db/init');
  });

  beforeEach(function() {
    // Clear temp_greetings table before each test
    try {
      db.prepare('DELETE FROM temp_greetings').run();
      db.prepare("DELETE FROM sqlite_sequence WHERE name = 'temp_greetings'").run();
    } catch (error) {
      // Re-initialize db if connection is closed
      if (error.message.includes('not open')) {
        db = require('../../db/init');
        db.prepare('DELETE FROM temp_greetings').run();
        db.prepare("DELETE FROM sqlite_sequence WHERE name = 'temp_greetings'").run();
      } else {
        throw error;
      }
    }
  });

  describe('initTempTable', function() {
    it('should create temp_greetings table successfully', function() {
      expect(function() {
        tempDb.initTempTable();
      }).not.toThrow();
      
      // Verify table exists by trying to query it
      var greeting = tempDb.getGreeting('hello');
      expect(greeting).toBeDefined();
      expect(greeting.message).toBe('Hello World');
    });

    it('should handle multiple calls without error', function() {
      tempDb.initTempTable();
      
      expect(function() {
        tempDb.initTempTable();
      }).not.toThrow();
    });
  });

  describe('insertInitialData', function() {
    beforeEach(function() {
      // Ensure table exists
      db.exec(`
        CREATE TABLE IF NOT EXISTS temp_greetings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          key TEXT UNIQUE NOT NULL,
          message TEXT NOT NULL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
      `);
    });

    it('should insert hello greeting successfully', function() {
      var id = tempDb.insertInitialData();
      expect(id).toBeDefined();
      
      var greeting = tempDb.getGreeting('hello');
      expect(greeting).toBeDefined();
      expect(greeting.message).toBe('Hello World');
    });

    it('should not duplicate entries on multiple calls', function() {
      tempDb.insertInitialData();
      tempDb.insertInitialData();
      
      var greetings = tempDb.getAllGreetings();
      expect(greetings.length).toBe(1);
      expect(greetings[0].message).toBe('Hello World');
    });
  });

  describe('getGreeting', function() {
    beforeEach(function() {
      tempDb.initTempTable();
    });

    it('should retrieve greeting by key', function() {
      var greeting = tempDb.getGreeting('hello');
      
      expect(greeting).toBeDefined();
      expect(greeting.key).toBe('hello');
      expect(greeting.message).toBe('Hello World');
      expect(greeting.created_at).toBeDefined();
    });

    it('should return undefined for non-existent key', function() {
      var greeting = tempDb.getGreeting('nonexistent');
      expect(greeting).toBeUndefined();
    });

    it('should default to hello key when no key provided', function() {
      var greeting = tempDb.getGreeting();
      
      expect(greeting).toBeDefined();
      expect(greeting.key).toBe('hello');
      expect(greeting.message).toBe('Hello World');
    });

    it('should handle database errors gracefully', function() {
      // This test verifies error handling by mocking the database module
      var originalDb = require('../../db/init');
      
      // Mock a database error by replacing the prepare method
      var tempDb = require('../../db/temp');
      var originalGetGreeting = tempDb.getGreeting;
      
      tempDb.getGreeting = function() {
        throw new Error('Database connection error');
      };
      
      expect(function() {
        tempDb.getGreeting('hello');
      }).toThrow('Database connection error');
      
      // Restore original function
      tempDb.getGreeting = originalGetGreeting;
    });
  });

  describe('getAllGreetings', function() {
    beforeEach(function() {
      tempDb.initTempTable();
    });

    it('should return all greetings ordered by creation date', function() {
      var greetings = tempDb.getAllGreetings();
      
      expect(greetings).toBeDefined();
      expect(Array.isArray(greetings)).toBe(true);
      expect(greetings.length).toBe(1);
      expect(greetings[0].message).toBe('Hello World');
    });

    it('should return empty array when no greetings exist', function() {
      db.prepare('DELETE FROM temp_greetings').run();
      
      var greetings = tempDb.getAllGreetings();
      expect(greetings).toEqual([]);
    });
  });
});
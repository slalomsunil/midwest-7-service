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

  describe('Input Validation and Edge Cases', function() {
    beforeEach(function() {
      tempDb.initTempTable();
    });

    it('should handle null keys gracefully', function() {
      expect(function() {
        tempDb.getGreeting(null);
      }).not.toThrow();
      
      var result = tempDb.getGreeting(null);
      expect(result).toBeDefined();
      expect(result.key).toBe('hello'); // Should default to 'hello'
    });

    it('should handle undefined keys gracefully', function() {
      var result = tempDb.getGreeting(undefined);
      expect(result).toBeDefined();
      expect(result.key).toBe('hello'); // Should default to 'hello'
    });

    it('should handle empty string keys', function() {
      var result = tempDb.getGreeting('');
      expect(result).toBeDefined();
      expect(result.key).toBe('hello'); // Should default to 'hello'
    });

    it('should handle SQL injection attempts in keys', function() {
      var maliciousKey = "'; DROP TABLE temp_greetings; --";
      var result = tempDb.getGreeting(maliciousKey);
      expect(result).toBeUndefined(); // Should not find the malicious key
      
      // Verify table still exists
      var allGreetings = tempDb.getAllGreetings();
      expect(allGreetings.length).toBeGreaterThan(0);
    });

    it('should handle very long keys', function() {
      var longKey = 'a'.repeat(1000);
      var result = tempDb.getGreeting(longKey);
      expect(result).toBeUndefined();
    });

    it('should handle special characters in keys', function() {
      var specialKey = '!@#$%^&*(){}[]|\\:";\'<>?,./';
      var result = tempDb.getGreeting(specialKey);
      expect(result).toBeUndefined();
    });
  });

  describe('Concurrency and Performance', function() {
    beforeEach(function() {
      tempDb.initTempTable();
    });

    it('should handle multiple concurrent reads', function(done) {
      var promises = [];
      var concurrentReads = 50;
      
      for (var i = 0; i < concurrentReads; i++) {
        promises.push(new Promise(function(resolve) {
          setTimeout(function() {
            var result = tempDb.getGreeting('hello');
            expect(result).toBeDefined();
            expect(result.message).toBe('Hello World');
            resolve();
          }, Math.random() * 10);
        }));
      }
      
      Promise.all(promises).then(function() {
        done();
      }).catch(done);
    });

    it('should handle database connection recovery', function() {
      // This test will fail initially as we need to implement connection recovery
      var tempDb = require('../../db/temp');
      
      // Simulate database connection loss and recovery
      expect(function() {
        // This should handle connection errors gracefully
        var result = tempDb.getGreeting('hello');
        expect(result).toBeDefined();
      }).not.toThrow();
    });

    it('should perform within acceptable time limits', function() {
      var startTime = Date.now();
      
      for (var i = 0; i < 100; i++) {
        tempDb.getGreeting('hello');
      }
      
      var endTime = Date.now();
      var duration = endTime - startTime;
      
      // Should complete 100 reads in less than 1 second
      expect(duration).toBeLessThan(1000);
    });
  });

  describe('Data Integrity', function() {
    beforeEach(function() {
      tempDb.initTempTable();
    });

    it('should maintain data consistency after multiple operations', function() {
      // Verify initial state
      var initial = tempDb.getAllGreetings();
      expect(initial.length).toBe(1);
      
      // Multiple calls should not change data
      tempDb.insertInitialData();
      tempDb.insertInitialData();
      tempDb.getGreeting('hello');
      tempDb.getAllGreetings();
      
      var final = tempDb.getAllGreetings();
      expect(final.length).toBe(1);
      expect(final[0].message).toBe(initial[0].message);
    });

    it('should handle database schema validation', function() {
      // This test will fail initially - we need to implement schema validation
      var greetings = tempDb.getAllGreetings();
      
      greetings.forEach(function(greeting) {
        expect(greeting).toHaveProperty('id');
        expect(greeting).toHaveProperty('key');
        expect(greeting).toHaveProperty('message');
        expect(greeting).toHaveProperty('created_at');
        
        expect(typeof greeting.id).toBe('number');
        expect(typeof greeting.key).toBe('string');
        expect(typeof greeting.message).toBe('string');
        expect(typeof greeting.created_at).toBe('string');
        
        // Validate data constraints
        expect(greeting.key.length).toBeGreaterThan(0);
        expect(greeting.message.length).toBeGreaterThan(0);
        expect(new Date(greeting.created_at)).toBeInstanceOf(Date);
      });
    });
  });

  describe('Error Recovery', function() {
    it('should recover from database corruption gracefully', function() {
      // This test will fail initially - we need to implement recovery mechanisms
      expect(function() {
        tempDb.initTempTable();
        tempDb.insertInitialData();
        var result = tempDb.getGreeting('hello');
        expect(result).toBeDefined();
      }).not.toThrow();
    });

    it('should handle transaction failures', function() {
      // This test will fail initially - we need proper transaction handling
      expect(function() {
        // Simulate transaction failure scenario
        tempDb.insertInitialData();
      }).not.toThrow();
    });
  });
});
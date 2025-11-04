var db = require('./init');

// Initialize temp table when module loads
function initTempTable() {
  try {
    // Create temp table for greetings
    db.exec(`
      CREATE TABLE IF NOT EXISTS temp_greetings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE NOT NULL,
        message TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    `);
    
    // Insert initial "Hello World" data if it doesn't exist
    var stmt = db.prepare('INSERT OR IGNORE INTO temp_greetings (key, message) VALUES (?, ?)');
    stmt.run('hello', 'Hello World');
    
    console.log('Temp greetings table initialized successfully');
    return true;
  } catch (error) {
    console.error('Failed to initialize temp greetings table:', error);
    throw error;
  }
}

// Initialize table when module is loaded
initTempTable();

var temp = {
  initTempTable: initTempTable,

  insertInitialData: function() {
    try {
      var stmt = db.prepare('INSERT OR IGNORE INTO temp_greetings (key, message) VALUES (?, ?)');
      var result = stmt.run('hello', 'Hello World');
      return result.lastInsertRowid;
    } catch (error) {
      console.error('Failed to insert initial greeting data:', error);
      throw error;
    }
  },

  getGreeting: function(key) {
    try {
      if (!key) {
        key = 'hello';
      }
      var stmt = db.prepare('SELECT * FROM temp_greetings WHERE key = ?');
      return stmt.get(key);
    } catch (error) {
      console.error('Failed to get greeting:', error);
      throw error;
    }
  },

  getAllGreetings: function() {
    try {
      var stmt = db.prepare('SELECT * FROM temp_greetings ORDER BY created_at DESC');
      return stmt.all();
    } catch (error) {
      console.error('Failed to get all greetings:', error);
      throw error;
    }
  }
};

module.exports = temp;
var Database = require('better-sqlite3');
var path = require('path');
var fs = require('fs');

describe('Chat Messages Schema', function() {
  var db;
  var testDbPath = path.join(__dirname, 'test-chat.db');

  beforeEach(function() {
    // Create fresh test database
    if (fs.existsSync(testDbPath)) {
      fs.unlinkSync(testDbPath);
    }
    db = new Database(testDbPath);
  });

  afterEach(function() {
    db.close();
    if (fs.existsSync(testDbPath)) {
      fs.unlinkSync(testDbPath);
    }
  });

  it('should create chat_messages table', function() {
    // Arrange & Act
    db.exec(`
      CREATE TABLE IF NOT EXISTS chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender_id INTEGER NOT NULL,
        receiver_id INTEGER NOT NULL,
        original_message TEXT NOT NULL,
        transformed_message TEXT NOT NULL,
        chat_mode TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Assert
    var tableInfo = db.prepare("PRAGMA table_info(chat_messages)").all();
    var columnNames = tableInfo.map(function(col) { return col.name; });
    
    expect(columnNames).toContain('id');
    expect(columnNames).toContain('sender_id');
    expect(columnNames).toContain('receiver_id');
    expect(columnNames).toContain('original_message');
    expect(columnNames).toContain('transformed_message');
    expect(columnNames).toContain('chat_mode');
    expect(columnNames).toContain('created_at');
  });

  it('should have indexes for efficient querying', function() {
    // Arrange & Act
    db.exec(`
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender_id INTEGER NOT NULL,
        receiver_id INTEGER NOT NULL,
        original_message TEXT NOT NULL,
        transformed_message TEXT NOT NULL,
        chat_mode TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
      CREATE INDEX idx_chat_messages_users ON chat_messages(sender_id, receiver_id, created_at DESC);
    `);

    // Assert
    var indexes = db.prepare("PRAGMA index_list(chat_messages)").all();
    var indexNames = indexes.map(function(idx) { return idx.name; });
    
    expect(indexNames).toContain('idx_chat_messages_users');
  });
});

var path = require('path');
var fs = require('fs');
var Database = require('better-sqlite3');

// Use Azure persistent storage if available, fallback to local
var isAzure = process.env.WEBSITE_INSTANCE_ID !== undefined;
var dbDir = isAzure ? '/home/data' : __dirname;
var dbPath = path.join(dbDir, 'cache.db');

// Create directory if it doesn't exist
if (!fs.existsSync(dbDir)) {
  fs.mkdirSync(dbDir, { recursive: true });
  console.log('Created database directory:', dbDir);
}

console.log('Initializing database at:', dbPath);

var db = new Database(dbPath, {
  verbose: process.env.NODE_ENV === 'development' ? console.log : undefined
});

// Set pragmas for better concurrency handling
db.pragma('journal_mode = WAL');
db.pragma('busy_timeout = 5000');
db.pragma('synchronous = NORMAL');

// Initialize tables
db.exec(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    display_name TEXT,
    bio TEXT,
    profile_image TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_active DATETIME DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE IF NOT EXISTS posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    image_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
  );

  CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(user_id);
  CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at DESC);
`);

// Add last_active column if it doesn't exist (migration)
try {
  db.exec('ALTER TABLE users ADD COLUMN last_active DATETIME DEFAULT CURRENT_TIMESTAMP');
  console.log('Added last_active column to users table');
} catch (error) {
  if (error.code !== 'SQLITE_ERROR' || !error.message.includes('duplicate column')) {
    console.error('Migration error:', error);
  }
  // Column already exists, continue
}

// Add is_online column if it doesn't exist (migration for presence tracking)
try {
  db.exec('ALTER TABLE users ADD COLUMN is_online INTEGER DEFAULT 0');
  console.log('Added is_online column to users table');
} catch (error) {
  if (error.code !== 'SQLITE_ERROR' || !error.message.includes('duplicate column')) {
    console.error('Migration error:', error);
  }
  // Column already exists, continue
}

// Create index for querying online users efficiently
try {
  db.exec('CREATE INDEX IF NOT EXISTS idx_users_online ON users(is_online) WHERE is_online = 1');
  console.log('Created index for online users');
} catch (error) {
  console.error('Index creation error:', error);
}

console.log('Database initialized successfully at:', dbPath);

module.exports = db;
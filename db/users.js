var db = require('./init');

var users = {
  create: function(username, displayName, bio, profileImage) {
    var stmt = db.prepare('INSERT INTO users (username, display_name, bio, profile_image, last_active) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)');
    var result = stmt.run(username, displayName, bio, profileImage);
    var id = result.lastInsertRowid;
    return this.findById(id);
  },

  findById: function(id) {
    var stmt = db.prepare('SELECT * FROM users WHERE id = ?');
    return stmt.get(id);
  },

  findByUsername: function(username) {
    var stmt = db.prepare('SELECT * FROM users WHERE username = ?');
    return stmt.get(username);
  },

  getAll: function() {
    var stmt = db.prepare('SELECT * FROM users ORDER BY created_at DESC');
    return stmt.all();
  },

  update: function(id, fields) {
    var updates = [];
    var values = [];
    
    if (fields.displayName !== undefined) {
      updates.push('display_name = ?');
      values.push(fields.displayName);
    }
    if (fields.bio !== undefined) {
      updates.push('bio = ?');
      values.push(fields.bio);
    }
    if (fields.profileImage !== undefined) {
      updates.push('profile_image = ?');
      values.push(fields.profileImage);
    }
    
    if (updates.length === 0) return false;
    
    values.push(id);
    var stmt = db.prepare('UPDATE users SET ' + updates.join(', ') + ' WHERE id = ?');
    var result = stmt.run(values);
    return result.changes > 0;
  },

  updateLastActive: function(id) {
    var stmt = db.prepare('UPDATE users SET last_active = CURRENT_TIMESTAMP WHERE id = ?');
    stmt.run(id);
    return this.findById(id);
  },

  clear: function() {
    var stmt = db.prepare('DELETE FROM users');
    stmt.run();
  }
};

module.exports = users;

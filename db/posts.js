var db = require('./init');

var posts = {
  create: function(userId, content, imageUrl) {
    var stmt = db.prepare('INSERT INTO posts (user_id, content, image_url) VALUES (?, ?, ?)');
    var result = stmt.run(userId, content, imageUrl);
    return result.lastInsertRowid;
  },

  findById: function(id) {
    var stmt = db.prepare(`
      SELECT p.*, u.username, u.display_name, u.profile_image
      FROM posts p
      JOIN users u ON p.user_id = u.id
      WHERE p.id = ?
    `);
    return stmt.get(id);
  },

  getAll: function(limit) {
    limit = limit || 50;
    var stmt = db.prepare(`
      SELECT p.*, u.username, u.display_name, u.profile_image
      FROM posts p
      JOIN users u ON p.user_id = u.id
      ORDER BY p.created_at DESC
      LIMIT ?
    `);
    return stmt.all(limit);
  },

  getByUser: function(userId, limit) {
    limit = limit || 50;
    var stmt = db.prepare(`
      SELECT p.*, u.username, u.display_name, u.profile_image
      FROM posts p
      JOIN users u ON p.user_id = u.id
      WHERE p.user_id = ?
      ORDER BY p.created_at DESC
      LIMIT ?
    `);
    return stmt.all(userId, limit);
  }
};

module.exports = posts;

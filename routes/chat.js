var express = require('express');
var router = express.Router();
var db = require('../db/init');

/**
 * GET /api/chat/messages
 * Fetch chat messages between two users
 */
router.get('/messages', function(req, res) {
  try {
    var userId = parseInt(req.query.userId);
    var partnerId = parseInt(req.query.partnerId);

    if (!userId || !partnerId) {
      return res.status(400).json({ error: 'Missing userId or partnerId' });
    }

    var messages = db.prepare(`
      SELECT 
        id,
        sender_id as senderId,
        receiver_id as receiverId,
        original_message as original,
        transformed_message as transformed,
        chat_mode as mode,
        created_at as createdAt
      FROM chat_messages
      WHERE (sender_id = ? AND receiver_id = ?) 
         OR (sender_id = ? AND receiver_id = ?)
      ORDER BY created_at ASC
    `).all(userId, partnerId, partnerId, userId);

    res.json({ messages: messages });
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({ error: 'Failed to fetch messages' });
  }
});

module.exports = router;

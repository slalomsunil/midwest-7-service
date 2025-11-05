var db = require('../db/init');
var messageTransformer = require('../services/messageTransformer');

var connectedUsers = new Map(); // userId -> socket.id

module.exports = function(io) {
  io.on('connection', function(socket) {
    console.log('User connected:', socket.id);

    // User joins
    socket.on('user-join', function(data) {
      var userId = data.userId;
      connectedUsers.set(userId, socket.id);
      socket.userId = userId;
      socket.join('user-' + userId);
      
      // Update online status
      db.prepare('UPDATE users SET is_online = 1, last_active = CURRENT_TIMESTAMP WHERE id = ?')
        .run(userId);
      
      // Broadcast user online
      socket.broadcast.emit('user-online', { userId: userId });
      
      console.log('User joined:', userId);
    });

    // Send message
    socket.on('send-message', async function(data) {
      try {
        var senderId = data.senderId;
        var receiverId = data.receiverId;
        var originalMessage = data.message;
        var chatMode = data.mode;

        console.log('📨 Message received from socket:', {
          senderId,
          receiverId,
          mode: chatMode,
          messagePreview: originalMessage.substring(0, 30)
        });

        // Transform message
        var transformedMessage = await messageTransformer.transform(originalMessage, chatMode);

        // Save to database
        var stmt = db.prepare(`
          INSERT INTO chat_messages (sender_id, receiver_id, original_message, transformed_message, chat_mode)
          VALUES (?, ?, ?, ?, ?)
        `);
        var result = stmt.run(senderId, receiverId, originalMessage, transformedMessage, chatMode);

        var messageData = {
          id: result.lastInsertRowid,
          senderId: senderId,
          receiverId: receiverId,
          original: originalMessage,
          transformed: transformedMessage,
          mode: chatMode,
          createdAt: new Date().toISOString()
        };

        // Send to receiver
        var receiverSocketId = connectedUsers.get(receiverId);
        if (receiverSocketId) {
          io.to('user-' + receiverId).emit('new-message', messageData);
          console.log('📬 Message delivered to receiver:', receiverId, 'via socket:', receiverSocketId);
        } else {
          console.log('⚠️  Receiver not connected:', receiverId);
        }

        // Confirm to sender
        socket.emit('message-sent', { 
          id: messageData.id,
          status: 'sent',
          transformed: transformedMessage
        });
        console.log('✅ Message confirmed to sender:', senderId);

        console.log('Message sent from', senderId, 'to', receiverId, 'in', chatMode, 'mode');
      } catch (error) {
        console.error('Error sending message:', error);
        socket.emit('message-error', { error: error.message });
      }
    });

    // User disconnects
    socket.on('disconnect', function() {
      var userId = socket.userId;
      if (userId) {
        connectedUsers.delete(userId);
        
        // Update online status
        db.prepare('UPDATE users SET is_online = 0, last_active = CURRENT_TIMESTAMP WHERE id = ?')
          .run(userId);
        
        // Check and cleanup chats
        cleanupChats(userId);
        
        // Broadcast user offline
        socket.broadcast.emit('user-offline', { userId: userId });
        
        console.log('User disconnected:', userId);
      }
    });
  });
};

function cleanupChats(userId) {
  // Get all users this user chatted with
  var chatPartners = db.prepare(`
    SELECT DISTINCT 
      CASE 
        WHEN sender_id = ? THEN receiver_id 
        ELSE sender_id 
      END as partner_id
    FROM chat_messages
    WHERE sender_id = ? OR receiver_id = ?
  `).all(userId, userId, userId);

  // For each partner, check if both are offline
  chatPartners.forEach(function(partner) {
    var partnerId = partner.partner_id;
    var partnerOnline = db.prepare('SELECT is_online FROM users WHERE id = ?')
      .get(partnerId);
    
    if (partnerOnline && partnerOnline.is_online === 0) {
      // Both offline - delete chat messages
      db.prepare(`
        DELETE FROM chat_messages 
        WHERE (sender_id = ? AND receiver_id = ?) 
           OR (sender_id = ? AND receiver_id = ?)
      `).run(userId, partnerId, partnerId, userId);
      
      console.log('Cleaned up chat between', userId, 'and', partnerId);
    }
  });
}

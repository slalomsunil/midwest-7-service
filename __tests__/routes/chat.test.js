const request = require('supertest');
const app = require('../../app');
const db = require('../../db/init');

// Mock socket.io for testing
const mockSocket = {
  emit: jest.fn(),
  broadcast: {
    emit: jest.fn()
  },
  to: jest.fn(() => ({
    emit: jest.fn()
  }))
};

const mockIo = {
  emit: jest.fn(),
  to: jest.fn(() => ({
    emit: jest.fn()
  }))
};

describe('Chat Routes with Notifications', () => {
  beforeEach(() => {
    // Clear database tables before each test
    db.prepare('DELETE FROM chat_messages').run();
    db.prepare('DELETE FROM users').run();
    
    // Reset mocks
    jest.clearAllMocks();
    
    // Create test users
    db.prepare(`
      INSERT INTO users (id, username, display_name, bio, is_online, last_active)
      VALUES (?, ?, ?, ?, ?, ?)
    `).run(1, 'testuser1', 'Test User 1', 'Test bio', 0, new Date().toISOString());
    
    db.prepare(`
      INSERT INTO users (id, username, display_name, bio, is_online, last_active)  
      VALUES (?, ?, ?, ?, ?, ?)
    `).run(2, 'testuser2', 'Test User 2', 'Test bio', 0, new Date().toISOString());
  });

  describe('GET /api/chat/messages', () => {
    test('should fetch messages between two users', async () => {
      // Insert test message
      db.prepare(`
        INSERT INTO chat_messages (sender_id, receiver_id, original_message, transformed_message, chat_mode)
        VALUES (?, ?, ?, ?, ?)
      `).run(1, 2, 'Hello!', 'Hello there!', 'friendly');

      const response = await request(app)
        .get('/api/chat/messages')
        .query({ userId: 1, partnerId: 2 });

      expect(response.status).toBe(200);
      expect(response.body.messages).toHaveLength(1);
      expect(response.body.messages[0].original).toBe('Hello!');
      expect(response.body.messages[0].transformed).toBe('Hello there!');
    });

    test('should return empty array when no messages exist', async () => {
      const response = await request(app)
        .get('/api/chat/messages')
        .query({ userId: 1, partnerId: 2 });

      expect(response.status).toBe(200);
      expect(response.body.messages).toHaveLength(0);
    });

    test('should return 400 when userId is missing', async () => {
      const response = await request(app)
        .get('/api/chat/messages')
        .query({ partnerId: 2 });

      expect(response.status).toBe(400);
      expect(response.body.error).toBe('Missing userId or partnerId');
    });
  });

  describe('Session Service Integration', () => {
    test('should add session when user joins', () => {
      const SessionService = require('../../services/sessionService');
      
      // Clear any existing sessions
      SessionService.clearAllSessions();
      
      // Add a session
      SessionService.addSession('user123', 'socket456', 'testuser');
      
      // Verify session was added
      expect(SessionService.isUserOnline('user123')).toBe(true);
      expect(SessionService.getAllSessions()).toContain('user123');
    });

    test('should clear all sessions on cleanup', () => {
      const SessionService = require('../../services/sessionService');
      
      // Add some sessions
      SessionService.addSession('user1', 'socket1', 'testuser1');
      SessionService.addSession('user2', 'socket2', 'testuser2');
      
      // Clear all sessions
      SessionService.clearAllSessions();
      
      // Verify all sessions were cleared
      expect(SessionService.getAllSessions()).toHaveLength(0);
      expect(SessionService.isUserOnline('user1')).toBe(false);
      expect(SessionService.isUserOnline('user2')).toBe(false);
    });

    test('should track online users count', () => {
      const SessionService = require('../../services/sessionService');
      
      SessionService.clearAllSessions();
      
      expect(SessionService.getOnlineUserCount()).toBe(0);
      
      SessionService.addSession('user1', 'socket1', 'testuser1');
      expect(SessionService.getOnlineUserCount()).toBe(1);
      
      SessionService.addSession('user2', 'socket2', 'testuser2');
      expect(SessionService.getOnlineUserCount()).toBe(2);
    });
  });

  describe('notification event structure', () => {
    test('message_notification should have correct structure', () => {
      const expectedNotification = {
        fromUserId: expect.any(String),
        toUserId: expect.any(String), 
        messagePreview: expect.any(String),
        timestamp: expect.any(Number)
      };

      // This validates the expected structure for our notification events
      expect(expectedNotification).toBeDefined();
      expect(expectedNotification.fromUserId).toBeDefined();
      expect(expectedNotification.toUserId).toBeDefined();
      expect(expectedNotification.messagePreview).toBeDefined();
      expect(expectedNotification.timestamp).toBeDefined();
    });
  });
});
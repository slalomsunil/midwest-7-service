const SessionService = require('../../services/sessionService');

describe('SessionService', () => {
  beforeEach(() => {
    SessionService.clearAllSessions();
  });

  describe('session management', () => {
    test('should add and track user sessions', () => {
      SessionService.addSession('user1', 'socket1');
      expect(SessionService.isUserOnline('user1')).toBe(true);
      expect(SessionService.getAllSessions()).toContain('user1');
    });

    test('should remove user sessions', () => {
      SessionService.addSession('user1', 'socket1');
      SessionService.removeSession('user1');
      expect(SessionService.isUserOnline('user1')).toBe(false);
      expect(SessionService.getAllSessions()).not.toContain('user1');
    });

    test('should track multiple user sessions', () => {
      SessionService.addSession('user1', 'socket1');
      SessionService.addSession('user2', 'socket2');
      
      expect(SessionService.getAllSessions()).toHaveLength(2);
      expect(SessionService.getAllSessions()).toContain('user1');
      expect(SessionService.getAllSessions()).toContain('user2');
    });

    test('should update session socket ID for existing user', () => {
      SessionService.addSession('user1', 'socket1');
      SessionService.addSession('user1', 'socket2');
      
      expect(SessionService.getAllSessions()).toHaveLength(1);
      expect(SessionService.isUserOnline('user1')).toBe(true);
    });
  });

  describe('session cleanup', () => {
    test('should clear all sessions on restart', () => {
      SessionService.addSession('user1', 'socket1');
      SessionService.addSession('user2', 'socket2');
      SessionService.addSession('user3', 'socket3');
      
      SessionService.clearAllSessions();
      
      expect(SessionService.getAllSessions()).toHaveLength(0);
      expect(SessionService.isUserOnline('user1')).toBe(false);
      expect(SessionService.isUserOnline('user2')).toBe(false);
      expect(SessionService.isUserOnline('user3')).toBe(false);
    });

    test('should return empty array when no sessions exist', () => {
      expect(SessionService.getAllSessions()).toHaveLength(0);
      expect(SessionService.getAllSessions()).toEqual([]);
    });
  });

  describe('session queries', () => {
    test('should return false for non-existent user', () => {
      expect(SessionService.isUserOnline('nonexistent')).toBe(false);
    });

    test('should handle session data with timestamps', () => {
      const beforeTime = Date.now();
      SessionService.addSession('user1', 'socket1');
      
      // Session should have been created with recent timestamp
      const sessions = SessionService.getAllSessions();
      expect(sessions).toContain('user1');
      
      // Assuming internal session data structure includes lastSeen
      const sessionData = SessionService.getSessionData('user1');
      expect(sessionData).toBeDefined();
      expect(sessionData.lastSeen).toBeGreaterThanOrEqual(beforeTime);
    });
  });
});
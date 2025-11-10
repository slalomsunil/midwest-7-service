/**
 * Session Service - Manages user sessions and online status
 * Handles session lifecycle, cleanup, and user tracking for the chat application
 */

class SessionService {
  constructor() {
    this.sessions = new Map(); // userId -> { socketId, lastSeen, username }
  }

  /**
   * Add a user session
   * @param {string} userId - User ID
   * @param {string} socketId - Socket connection ID
   * @param {string} username - Username (optional)
   */
  addSession(userId, socketId, username = null) {
    this.sessions.set(userId, {
      socketId,
      lastSeen: Date.now(),
      username
    });
  }

  /**
   * Remove a user session
   * @param {string} userId - User ID to remove
   */
  removeSession(userId) {
    const removed = this.sessions.delete(userId);
    return removed;
  }

  /**
   * Remove session by socket ID
   * @param {string} socketId - Socket ID to remove
   * @returns {string|null} - Removed user ID or null
   */
  removeSessionBySocketId(socketId) {
    for (const [userId, sessionData] of this.sessions.entries()) {
      if (sessionData.socketId === socketId) {
        this.removeSession(userId);
        return userId;
      }
    }
    return null;
  }

  /**
   * Clear all sessions (used on server restart)
   */
  clearAllSessions() {
    const sessionCount = this.sessions.size;
    this.sessions.clear();
  }

  /**
   * Get all online user IDs
   * @returns {string[]} - Array of user IDs
   */
  getAllSessions() {
    return Array.from(this.sessions.keys());
  }

  /**
   * Check if a user is online
   * @param {string} userId - User ID to check
   * @returns {boolean} - True if user is online
   */
  isUserOnline(userId) {
    return this.sessions.has(userId);
  }

  /**
   * Get session data for a user
   * @param {string} userId - User ID
   * @returns {object|null} - Session data or null
   */
  getSessionData(userId) {
    return this.sessions.get(userId) || null;
  }

  /**
   * Get socket ID for a user
   * @param {string} userId - User ID
   * @returns {string|null} - Socket ID or null
   */
  getSocketId(userId) {
    const sessionData = this.sessions.get(userId);
    return sessionData ? sessionData.socketId : null;
  }

  /**
   * Update last seen timestamp for a user
   * @param {string} userId - User ID
   */
  updateLastSeen(userId) {
    const sessionData = this.sessions.get(userId);
    if (sessionData) {
      sessionData.lastSeen = Date.now();
    }
  }

  /**
   * Get count of online users
   * @returns {number} - Number of online users
   */
  getOnlineUserCount() {
    return this.sessions.size;
  }

  /**
   * Get online users with their data
   * @returns {Array} - Array of online user data
   */
  getOnlineUsersWithData() {
    const users = [];
    for (const [userId, sessionData] of this.sessions.entries()) {
      users.push({
        userId,
        socketId: sessionData.socketId,
        lastSeen: sessionData.lastSeen,
        username: sessionData.username
      });
    }
    return users;
  }
}

// Export singleton instance
module.exports = new SessionService();
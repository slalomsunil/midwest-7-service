const express = require('express');
const usersDb = require('../db/users');
const router = express.Router();

/**
 * POST /api/auth/login
 * Authenticate user with username-only login
 * Creates new user if doesn't exist, returns existing user if found
 */
router.post('/login', async (req, res) => {
  try {
    const { username } = req.body;

    // Validate required fields
    if (username === undefined || username === null) {
      return res.status(400).json({
        success: false,
        error: 'Username is required'
      });
    }

    // Validate username format
    if (typeof username !== 'string') {
      return res.status(400).json({
        success: false,
        error: 'Username must be a string'
      });
    }

    if (username.trim() === '') {
      return res.status(400).json({
        success: false,
        error: 'Username cannot be empty'
      });
    }

    // Validate username length
    if (username.length > 50) {
      return res.status(400).json({
        success: false,
        error: 'Username must be 50 characters or less'
      });
    }

    const trimmedUsername = username.trim();

    // Check if user exists
    let user = usersDb.findByUsername(trimmedUsername);

    if (user) {
      // Update last active timestamp for existing user
      user = usersDb.updateLastActive(user.id);
    } else {
      // Create new user
      user = usersDb.create(trimmedUsername);
    }

    // Return user data (excluding any sensitive information)
    const safeUser = {
      id: user.id,
      username: user.username,
      createdAt: user.created_at,
      lastActive: user.last_active
    };

    res.json({
      success: true,
      user: safeUser
    });

  } catch (error) {
    console.error('Auth login error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error'
    });
  }
});

/**
 * POST /api/auth/logout
 * Handle user logout (mostly for client-side session clearing)
 */
router.post('/logout', async (req, res) => {
  try {
    // In a username-only system, logout is mainly client-side
    // We could update lastActive timestamp if needed
    const { username } = req.body;

    if (username) {
      const user = usersDb.findByUsername(username);
      if (user) {
        usersDb.updateLastActive(user.id);
      }
    }

    res.json({
      success: true,
      message: 'Logged out successfully'
    });

  } catch (error) {
    console.error('Auth logout error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error'
    });
  }
});

module.exports = router;
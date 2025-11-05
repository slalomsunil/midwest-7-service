var express = require('express');
var router = express.Router();
var usersDb = require('../db/users');

/**
 * @swagger
 * /users:
 *   get:
 *     summary: Get all users
 *     description: Retrieve a list of all users
 *     tags: [Users]
 *     responses:
 *       200:
 *         description: List of users
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/User'
 */
router.get('/', function(req, res, next) {
  try {
    var users = usersDb.getAll();
    res.json(users);
  } catch (err) {
    next(err);
  }
});

/**
 * @swagger
 * /users/online:
 *   get:
 *     summary: Get all currently online users
 *     description: Retrieve a list of users who are currently logged in, excluding the requesting user
 *     tags: [Users]
 *     parameters:
 *       - in: query
 *         name: excludeUserId
 *         schema:
 *           type: integer
 *         description: User ID to exclude from results (typically the current user)
 *     responses:
 *       200:
 *         description: List of online users
 *         headers:
 *           Cache-Control:
 *             description: Caching directives to optimize polling
 *             schema:
 *               type: string
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 users:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                       username:
 *                         type: string
 *                       display_name:
 *                         type: string
 *                       profile_image:
 *                         type: string
 *                       last_active:
 *                         type: string
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/online', function(req, res, next) {
  try {
    var excludeUserId = req.query.excludeUserId ? parseInt(req.query.excludeUserId, 10) : null;
    var users = usersDb.getActiveUsers({ excludeUserId: excludeUserId });
    
    // Set cache headers to optimize polling - allow caching for 3 seconds
    res.set('Cache-Control', 'public, max-age=3');
    
    res.json({
      success: true,
      users: users
    });
  } catch (err) {
    next(err);
  }
});

/**
 * @swagger
 * /users/{id}:
 *   get:
 *     summary: Get a user by ID
 *     description: Retrieve a single user by their ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: User ID
 *     responses:
 *       200:
 *         description: User details
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/User'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/:id', function(req, res, next) {
  try {
    var user = usersDb.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  } catch (err) {
    next(err);
  }
});

/**
 * @swagger
 * /users:
 *   post:
 *     summary: Create a new user
 *     description: Create a new user account
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - username
 *             properties:
 *               username:
 *                 type: string
 *                 description: Unique username
 *               displayName:
 *                 type: string
 *                 description: Display name
 *               bio:
 *                 type: string
 *                 description: User biography
 *               profileImage:
 *                 type: string
 *                 description: Profile image URL
 *     responses:
 *       201:
 *         description: User created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/User'
 *       400:
 *         description: Username is required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       409:
 *         description: Username already exists
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post('/', function(req, res, next) {
  try {
    var { username, displayName, bio, profileImage } = req.body;
    if (!username) {
      return res.status(400).json({ error: 'Username is required' });
    }
    var user = usersDb.create(username, displayName, bio, profileImage);
    res.status(201).json(user);
  } catch (err) {
    if (err.message.includes('UNIQUE constraint failed')) {
      return res.status(409).json({ error: 'Username already exists' });
    }
    next(err);
  }
});

/**
 * @swagger
 * /users/{id}:
 *   put:
 *     summary: Update a user
 *     description: Update user information
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: User ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               displayName:
 *                 type: string
 *                 description: Display name
 *               bio:
 *                 type: string
 *                 description: User biography
 *               profileImage:
 *                 type: string
 *                 description: Profile image URL
 *     responses:
 *       200:
 *         description: User updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/User'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.put('/:id', function(req, res, next) {
  try {
    var updated = usersDb.update(req.params.id, req.body);
    if (!updated) {
      return res.status(404).json({ error: 'User not found' });
    }
    var user = usersDb.findById(req.params.id);
    res.json(user);
  } catch (err) {
    next(err);
  }
});

module.exports = router;

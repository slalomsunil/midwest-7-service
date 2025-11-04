var swaggerJsdoc = require('swagger-jsdoc');

var options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Midwest 7 Service API',
      version: '1.0.0',
      description: 'Social Media POC API - Express.js service with SQLite persistent storage',
      contact: {
        name: 'API Support'
      }
    },
    servers: [
      {
        url: 'http://localhost:8081',
        description: 'Development server'
      }
    ],
    components: {
      schemas: {
        User: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              description: 'User ID'
            },
            username: {
              type: 'string',
              description: 'Unique username'
            },
            display_name: {
              type: 'string',
              description: 'Display name'
            },
            bio: {
              type: 'string',
              description: 'User biography'
            },
            profile_image: {
              type: 'string',
              description: 'Profile image URL'
            },
            created_at: {
              type: 'string',
              format: 'date-time',
              description: 'Account creation timestamp'
            }
          }
        },
        Post: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              description: 'Post ID'
            },
            user_id: {
              type: 'integer',
              description: 'ID of the user who created the post'
            },
            content: {
              type: 'string',
              description: 'Post content'
            },
            image_url: {
              type: 'string',
              description: 'Image URL'
            },
            created_at: {
              type: 'string',
              format: 'date-time',
              description: 'Post creation timestamp'
            },
            username: {
              type: 'string',
              description: 'Username of post author'
            },
            display_name: {
              type: 'string',
              description: 'Display name of post author'
            },
            profile_image: {
              type: 'string',
              description: 'Profile image of post author'
            }
          }
        },
        Error: {
          type: 'object',
          properties: {
            error: {
              type: 'string',
              description: 'Error message'
            }
          }
        }
      }
    }
  },
  apis: ['./routes/*.js']
};

var swaggerSpec = swaggerJsdoc(options);

module.exports = swaggerSpec;

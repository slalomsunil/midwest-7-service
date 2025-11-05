var NodeCache = require('node-cache');
var aiClient = require('./aiClient');

var cache = new NodeCache({ stdTTL: 3600 }); // 1 hour cache

var validModes = ['pirate', 'shakespeare', 'robot', 'horror', 'party', 
                  'fantasy', 'alien', 'detective', 'corporate', 'genz'];

async function transform(message, chatMode) {
  // Validate input
  if (!message || message.trim() === '') {
    throw new Error('Message cannot be empty');
  }
  
  if (!validModes.includes(chatMode)) {
    throw new Error('Invalid chat mode: ' + chatMode);
  }
  
  // Check cache
  var cacheKey = chatMode + ':' + message.trim();
  var cached = cache.get(cacheKey);
  if (cached) {
    return cached;
  }
  
  // Transform via AI
  var transformed = await aiClient.transformMessage(message, chatMode);
  
  // Cache result
  cache.set(cacheKey, transformed);
  
  return transformed;
}

function clearCache() {
  cache.flushAll();
}

module.exports = { 
  transform: transform,
  clearCache: clearCache
};

require('dotenv').config();

var aiConfig = {
  endpoint: process.env.AZURE_OPENAI_ENDPOINT,
  apiKey: process.env.AZURE_OPENAI_API_KEY,
  deployment: process.env.AZURE_OPENAI_DEPLOYMENT || 'gpt-4o-mini',
  apiVersion: process.env.AZURE_OPENAI_API_VERSION || '2025-01-01-preview',
  maxTokens: 150,
  temperature: 0.7,
  topP: 1.0
};

// Validate required configuration
if (!aiConfig.endpoint || !aiConfig.apiKey) {
  throw new Error('AZURE_OPENAI_ENDPOINT and AZURE_OPENAI_API_KEY must be set in environment variables');
}

module.exports = aiConfig;

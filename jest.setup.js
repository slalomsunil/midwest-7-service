// Jest setup file - runs before all tests
// Set up environment variables for testing

// Mock Azure OpenAI environment variables if not already set
if (!process.env.AZURE_OPENAI_ENDPOINT) {
  process.env.AZURE_OPENAI_ENDPOINT = 'https://test-openai.openai.azure.com/';
}

if (!process.env.AZURE_OPENAI_API_KEY) {
  process.env.AZURE_OPENAI_API_KEY = 'test-api-key-for-testing';
}

if (!process.env.AZURE_OPENAI_DEPLOYMENT) {
  process.env.AZURE_OPENAI_DEPLOYMENT = 'gpt-4o-mini';
}

if (!process.env.AZURE_OPENAI_API_VERSION) {
  process.env.AZURE_OPENAI_API_VERSION = '2025-01-01-preview';
}

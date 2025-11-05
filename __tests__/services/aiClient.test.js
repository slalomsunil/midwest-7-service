var aiClient = require('../../services/aiClient');
var axios = require('axios');

jest.mock('axios');

describe('AI Client Service', function() {
  afterEach(function() {
    jest.clearAllMocks();
  });

  it('should transform message with pirate mode', async function() {
    // Arrange
    var mockResponse = {
      data: {
        choices: [{
          message: {
            content: 'Ahoy matey! How be ye? ⚓🏴‍☠️'
          }
        }]
      }
    };
    axios.post.mockResolvedValue(mockResponse);

    // Act
    var result = await aiClient.transformMessage('How are you?', 'pirate');

    // Assert
    expect(result).toBe('Ahoy matey! How be ye? ⚓🏴‍☠️');
    expect(axios.post).toHaveBeenCalledWith(
      expect.stringContaining('/chat/completions'),
      expect.objectContaining({
        messages: expect.arrayContaining([
          expect.objectContaining({ role: 'system' }),
          expect.objectContaining({ role: 'user', content: 'How are you?' })
        ]),
        model: expect.any(String)
      }),
      expect.objectContaining({
        headers: expect.objectContaining({
          'api-key': expect.any(String)
        })
      })
    );
  });

  it('should use fallback when AI service fails', async function() {
    // Arrange
    axios.post.mockRejectedValue(new Error('Network error'));

    // Act
    var result = await aiClient.transformMessage('Hello', 'robot');

    // Assert
    expect(result).toBe('Hello 🤖⚙️');
  });

  it('should handle timeout errors', async function() {
    // Arrange
    axios.post.mockRejectedValue({ code: 'ECONNABORTED' });

    // Act
    var result = await aiClient.transformMessage('Test', 'shakespeare');

    // Assert
    expect(result).toContain('Test');
    expect(result).toContain('📜✨');
  });

  it('should handle all 10 chat modes', async function() {
    // Arrange
    var modes = ['pirate', 'shakespeare', 'robot', 'horror', 'party', 
                 'fantasy', 'alien', 'detective', 'corporate', 'genz'];
    axios.post.mockResolvedValue({
      data: { choices: [{ message: { content: 'Transformed ✨' } }] }
    });

    // Act & Assert
    for (var mode of modes) {
      var result = await aiClient.transformMessage('test', mode);
      expect(result).toBe('Transformed ✨');
    }
    
    expect(axios.post).toHaveBeenCalledTimes(10);
  });
});

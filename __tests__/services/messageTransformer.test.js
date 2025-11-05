var messageTransformer = require('../../services/messageTransformer');
var aiClient = require('../../services/aiClient');

jest.mock('../../services/aiClient');

describe('Message Transformer Service', function() {
  beforeEach(function() {
    jest.clearAllMocks();
    messageTransformer.clearCache();
    aiClient.transformMessage.mockResolvedValue('Ahoy matey! ⚓');
  });

  it('should transform message using AI client', async function() {
    // Act
    var result = await messageTransformer.transform('Hello', 'pirate');

    // Assert
    expect(result).toBe('Ahoy matey! ⚓');
    expect(aiClient.transformMessage).toHaveBeenCalledWith('Hello', 'pirate');
  });

  it('should cache transformed messages', async function() {
    // Act
    var result1 = await messageTransformer.transform('Hello', 'pirate');
    var result2 = await messageTransformer.transform('Hello', 'pirate');

    // Assert
    expect(result1).toBe('Ahoy matey! ⚓');
    expect(result2).toBe('Ahoy matey! ⚓');
    expect(aiClient.transformMessage).toHaveBeenCalledTimes(1); // Called once, cached second time
  });

  it('should handle different modes separately in cache', async function() {
    // Arrange
    aiClient.transformMessage
      .mockResolvedValueOnce('Ahoy! ⚓')
      .mockResolvedValueOnce('BEEP.BOOP 🤖');

    // Act
    var pirate = await messageTransformer.transform('Hi', 'pirate');
    var robot = await messageTransformer.transform('Hi', 'robot');

    // Assert
    expect(pirate).toBe('Ahoy! ⚓');
    expect(robot).toBe('BEEP.BOOP 🤖');
    expect(aiClient.transformMessage).toHaveBeenCalledTimes(2);
  });

  it('should validate message input', async function() {
    // Act & Assert
    await expect(messageTransformer.transform('', 'pirate')).rejects.toThrow('Message cannot be empty');
    await expect(messageTransformer.transform(null, 'pirate')).rejects.toThrow('Message cannot be empty');
  });

  it('should validate chat mode', async function() {
    // Act & Assert
    await expect(messageTransformer.transform('Hello', 'invalid')).rejects.toThrow('Invalid chat mode');
  });
});

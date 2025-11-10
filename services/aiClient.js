var axios = require('axios');
var aiConfig = require('../config/aiConfig');

var chatModePrompts = {
  pirate: 'Transform this message into pirate-speak with nautical personality. Add emojis: ⚓🏴‍☠️☠️🦜. Keep it under 2 sentences.',
  shakespeare: 'Transform into Shakespearean English with classical flair. Add emojis: 📜✨🎭. Keep it under 2 sentences.',
  robot: 'Transform into robotic/mechanical speech. Add emojis: 🤖🔧⚙️. Keep it under 2 sentences.',
  horror: 'Transform into eerie, mysterious tone. Add emojis: 👻🕷️🌑. Keep it under 2 sentences.',
  party: 'Transform into super excited, energetic party mode. Add emojis: 🥳💃🎉. Keep it under 2 sentences.',
  fantasy: 'Transform into mystical fantasy language. Add emojis: ✨🐉🧙‍♂️. Keep it under 2 sentences.',
  alien: 'Transform into alien/extraterrestrial speech. Add emojis: 🛸👾👽. Keep it under 2 sentences.',
  detective: 'Transform into detective/investigative tone. Add emojis: 🔍📝🕵️. Keep it under 2 sentences.',
  corporate: 'Transform into corporate jargon with buzzwords. Add emojis: 📊💼💻. Keep it under 2 sentences.',
  genz: 'Transform into Gen Z slang and expressions. Add emojis: 💅✨🔥. Keep it under 2 sentences.'
};

async function transformMessage(message, chatMode) {
  var systemPrompt = chatModePrompts[chatMode] || chatModePrompts.pirate;
  
  try {
    var url = aiConfig.endpoint + '/openai/deployments/' + aiConfig.deployment + 
              '/chat/completions?api-version=' + aiConfig.apiVersion;
    
    var requestPayload = {
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: message }
      ],
      max_tokens: aiConfig.maxTokens,
      temperature: aiConfig.temperature,
      top_p: aiConfig.topP,
      model: aiConfig.deployment
    };
    
    var startTime = Date.now();
    
    var response = await axios.post(
      url,
      requestPayload,
      {
        headers: {
          'api-key': aiConfig.apiKey,
          'Content-Type': 'application/json'
        },
        timeout: 5000
      }
    );

    var endTime = Date.now();
    var duration = endTime - startTime;
    var transformedMessage = response.data.choices[0].message.content.trim();

    return transformedMessage;
  } catch (error) {
    console.error('❌ AI TRANSFORMATION ERROR:', {
      mode: chatMode,
      originalMessage: message,
      errorMessage: error.message,
      errorCode: error.code,
      timestamp: new Date().toISOString()
    });
    
    var fallbackMessage = getFallbackMessage(message, chatMode);
    
    return fallbackMessage;
  }
}

function getFallbackMessage(message, chatMode) {
  var modeEmojis = {
    pirate: ' ⚓🏴‍☠️',
    shakespeare: ' 📜✨',
    robot: ' 🤖⚙️',
    horror: ' 👻🕷️',
    party: ' 🥳🎉',
    fantasy: ' ✨🐉',
    alien: ' 🛸👾',
    detective: ' 🔍📝',
    corporate: ' 📊💼',
    genz: ' 💅✨'
  };
  
  return message + (modeEmojis[chatMode] || ' ✨');
}

module.exports = {
  transformMessage: transformMessage
};

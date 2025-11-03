# AI Code Poet Style Guide

## Poetry Style Guidelines

### Haiku Style
- **Structure**: 5-7-5 syllable pattern
- **Themes**: Nature, seasons, simplicity, zen-like observations
- **Tone**: Contemplative, peaceful, insightful
- **Best for**: Simple functions, data transformations, utility methods

Example:
```javascript
// Data flows like streams (5)
// Through functions, pure and serene (7)
// State blooms, then transcends (5)
```

### Sonnet Style
- **Structure**: 14 lines with ABAB CDCD EFEF GG rhyme scheme
- **Themes**: Technical mastery, complex systems, architectural beauty
- **Tone**: Formal, elevated, celebratory
- **Best for**: Complex algorithms, system architecture, major components

### Free Verse Style
- **Structure**: No fixed pattern, natural rhythm
- **Themes**: Process, journey, transformation, human experience
- **Tone**: Conversational, emotional, relatable
- **Best for**: Business logic, user interactions, workflows

### Limerick Style
- **Structure**: AABBA rhyme scheme, bouncy rhythm
- **Themes**: Humor, wordplay, light technical concepts
- **Tone**: Playful, witty, entertaining
- **Best for**: Error handling, edge cases, simple utilities

## Metaphor Categories

### Data Structures
- Arrays as gardens, forests, or rivers
- Objects as buildings, containers, or characters
- Maps as landscapes or territories
- Trees as actual trees with branches and leaves

### Algorithms
- Sorting as organizing, cleaning, or arranging
- Searching as exploration, hunting, or discovery
- Recursion as mirrors, echoes, or fractals
- Loops as circles, cycles, or dances

### System Architecture
- Modules as rooms in a house
- Services as different shops in a town
- APIs as bridges or doorways
- Databases as libraries or vaults

## Quality Guidelines

### Do
- Use vivid, specific imagery
- Maintain technical accuracy
- Respect the original code's intent
- Keep metaphors consistent within a file
- Consider the audience (technical vs. general)

### Don't
- Obscure the code's actual purpose
- Use overly complex or confusing metaphors
- Mix incompatible imagery styles
- Make light of serious security or error conditions
- Use inappropriate or offensive language

## Configuration Options

```typescript
interface PoetryConfig {
  defaultStyle: PoetryStyle;
  metaphorIntensity: 'subtle' | 'moderate' | 'vivid';
  technicalAccuracy: 'loose' | 'balanced' | 'strict';
  humorLevel: 'none' | 'light' | 'moderate';
  customThemes?: string[];
}
```
# Templates Directory

This directory contains templates organized by their intended use:

## Directory Structure

- **`content/`** - Rule content templates that are copied/adapted for actual project rules
  - BASE_* templates - Core behavioral rules applied to all interactions
  - SDLC_* templates - Phase-specific rules for development lifecycle stages  
  - TECH_* templates - Technology-specific rules for different languages/frameworks

- **`adapters/`** - Instructions for adapting the modular rules system to specific AI tools
  - Tool-specific implementation guides
  - File structure recommendations per tool
  - Integration patterns and conventions

- **`structure/`** - System architecture and organization templates
  - Router logic and rule composition patterns
  - Project context templates for customization

## Usage

**Content Templates**: Copy and customize these for your actual project rules. They contain the rule content itself.

**Adapter Templates**: Follow these instructions when setting up rules for specific AI tools like Claude, Copilot, or Cursor.

**Structure Templates**: Use these to understand and implement the overall rules system architecture.

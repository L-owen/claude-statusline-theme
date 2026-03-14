# Claude Statusline Theme

A beautiful, feature-rich status line theme for Claude Code.

![Status Line Preview](https://img.shields.io/badge/Claude-Code-success?style=for-the-badge)

## Available Versions

This repository includes three versions of the status line theme:

### 1. **statusline-emoji.sh** (Simple Version)
- Pure emoji icons, works everywhere
- No color codes
- Lightweight and universal
- Best for terminals with limited color support

### 2. **statusline-nerd.sh** (Nerd Font Version) ⭐ Recommended
- Nerd Font icons for beautiful visuals
- 256-color mode support
- Color-coded components
- Enhanced visual experience
- Requires terminal with Nerd Font support (e.g., MesloLGS NF, JetBrains Mono Nerd Font)

### 3. **statusline-colored.sh** (Colored Version)
- 256-color mode support for better visibility
- Color-coded components
- Enhanced visual experience
- Requires terminal with 256-color support

## Features

- 🕐 **Current Time** - Always know what time it is
- ✨ **Model Display** - Shows Claude model (Sonnet/Opus/Haiku)
- 🌿 **Git Branch & Status** - Visual indicators for:
  - `✓` Staged changes
  - `•` Modified files
  - `+` Untracked files
  - `↑` Unpushed commits
- 🟢🟡🔴 **Context Window** - Color-coded by remaining percentage
  - 🟢 Green: >50%
  - 🟡 Yellow: 20-50%
  - 🔴 Red: <20%
- 💬 **Token Usage** - Input/output tokens with k/M suffixes
- 🔋⚡🪫 **Battery Status** - macOS only, shows percentage and charging state
- 💎 **Node.js Version** - Display current Node version if available
- 📂 **Directory Path** - Current working directory with ~ for home

## Installation

Choose the version you prefer:

### Simple Emoji Version (For maximum compatibility)
```bash
cp statusline-emoji.sh ~/.claude/
chmod +x ~/.claude/statusline-emoji.sh
```

### Nerd Font Version (Recommended - Beautiful & Feature-rich)
```bash
cp statusline-nerd.sh ~/.claude/
chmod +x ~/.claude/statusline-nerd.sh
```

### Colored Version (Alternative colored theme)
```bash
cp statusline-colored.sh ~/.claude/
chmod +x ~/.claude/statusline-colored.sh
```

Then add to your `~/.claude/settings.json`:

**For emoji version:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline-emoji.sh"
  }
}
```

**For Nerd Font version (recommended):**
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline-nerd.sh"
  }
}
```

**For colored version:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline-colored.sh"
  }
}
```

Restart Claude Code after making changes.

## Requirements

- **jq** - JSON processor for parsing Claude's input
  ```bash
  brew install jq  # macOS
  ```

## Customization

You can easily customize the theme by editing `statusline-command.sh`:

### Change Separator
Edit line 179:
```bash
IFS=" | "  # Change to whatever you like
```

### Remove Components
Comment out the sections you don't need:
```bash
# To remove battery:
# if command -v pmset &> /dev/null; then
#   ...
# fi
```

### Add Custom Components
Add your own logic following the same pattern:
```bash
# Example: Python version
if command -v python &> /dev/null; then
  python_version=$(python --version 2>/dev/null | awk '{print $2}')
  components+=("🐍 ${python_version}")
fi
```

## Preview

### Emoji Version
```
🕐 14:30 | ✨ Sonnet | 🌿 main•+ | 🟢 75% | 💬 12k/3k | 🔋 85% | 💎 v20.11.0 | 📂 ~/projects/my-app
```

### Nerd Font Version (Recommended)
```
󰥔 14:30 │  Sonnet │  main •+ │  75% │  12k/3k │  85% │ 󰎙 v20.11.0 │  ~/projects/my-app
```
*With beautiful 256-color coding for each component*

### Colored Version
```
🕐 14:30 | ✨ Sonnet | 🌿 main•+ | 🟢 75% | 💬 12k/3k | 🔋 85% | 💎 v20.11.0 | 📂 ~/projects/my-app
```
*With color-coded components*

## License

MIT

## Author

Created by [@L-owen](https://github.com/L-owen)

## Contributing

Feel free to submit issues and pull requests!

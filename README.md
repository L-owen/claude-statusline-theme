# Claude Statusline Theme

A beautiful, feature-rich status line theme for Claude Code.

![Status Line Preview](https://img.shields.io/badge/Claude-Code-success?style=for-the-badge)

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

1. Copy the script to your Claude config directory:
   ```bash
   cp statusline-command.sh ~/.claude/
   chmod +x ~/.claude/statusline-command.sh
   ```

2. Add to your `~/.claude/settings.json`:
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "~/.claude/statusline-command.sh"
     }
   }
   ```

3. Restart Claude Code

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

```
🕐 14:30 | ✨ Sonnet | 🌿 main•+ | 🟢 75% | 💬 12k/3k | 🔋 85% | 💎 v20.11.0 | 📂 ~/projects/my-app
```

## License

MIT

## Author

Created by [@L-owen](https://github.com/L-owen)

## Contributing

Feel free to submit issues and pull requests!

#!/bin/bash

# 颜色定义 - 使用 256 色模式适配 iTerm2
COLOR_RESET='\033[0m'
COLOR_TIME='\033[38;5;38m'        # 青色 - 时间
COLOR_MODEL='\033[38;5;141m'      # 紫色 - 模型
COLOR_GIT='\033[38;5;71m'         # 绿色 - Git 分支
COLOR_GIT_STAGED='\033[38;5;71m'  # 绿色 - 已暂存
COLOR_GIT_MODIFIED='\033[38;5;208m' # 橙色 - 已修改
COLOR_GIT_UNTRACKED='\033[38;5;220m' # 黄色 - 未跟踪
COLOR_GIT_UNPUSHED='\033[38;5;203m'  # 红色 - 未推送
COLOR_CONTEXT='\033[38;5;39m'     # 蓝色 - Token 使用量
COLOR_TOKENS='\033[38;5;75m'      # 浅蓝 - Token 详情
COLOR_BATTERY='\033[38;5;226m'    # 黄色 - 电池
COLOR_BATTERY_LOW='\033[38;5;203m' # 红色 - 低电量
COLOR_NODE='\033[38;5;34m'        # 绿色 - Node.js
COLOR_DIR='\033[38;5;245m'        # 灰色 - 目录
COLOR_SEPARATOR='\033[38;5;240m'  # 深灰 - 分隔符

# Read JSON input from stdin
input=$(cat)

# Extract fields using jq with proper error handling
model=$(echo "$input" | jq -r '.model.display_name // "Claude"' 2>/dev/null)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // empty' 2>/dev/null)

# Get context window info - prefer remaining over used
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty' 2>/dev/null)
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)

# Get current token usage
current_usage=$(echo "$input" | jq -r '.context_window.current_usage // empty' 2>/dev/null)

# Build status components
components=()

# 1. Add time
current_time=$(date +"%H:%M" 2>/dev/null)
if [ -n "$current_time" ]; then
  components+=("🕐 ${current_time}")
fi

# 2. Add model
if [ -n "$model" ] && [ "$model" != "null" ]; then
  case "$model" in
    *Sonnet*) model_display="Sonnet" ;;
    *Opus*) model_display="Opus" ;;
    *Haiku*) model_display="Haiku" ;;
    *) model_display="$model" ;;
  esac
  components+=(" ${model_display}")
fi

# Get git branch and status
git_info=""
if [ -n "$current_dir" ] && [ -d "$current_dir" ]; then
  git_branch=$(cd "$current_dir" 2>/dev/null && git branch --show-current 2>/dev/null)

  if [ -n "$git_branch" ]; then
    git_status=$(cd "$current_dir" 2>/dev/null && git status --porcelain 2>/dev/null --no-optional-locks)

    has_staged=false
    has_modified=false
    has_untracked=false
    has_unpushed=false

    if [ -n "$git_status" ]; then
      if echo "$git_status" | grep -q "^M "; then
        has_modified=true
      fi
      if echo "$git_status" | grep -q "^M"; then
        has_staged=true
      fi
      if echo "$git_status" | grep -q "^??"; then
        has_untracked=true
      fi
    fi

    if [ -n "$git_branch" ]; then
      unpushed=$(cd "$current_dir" 2>/dev/null && git rev-list --count --left-right @{u}...HEAD 2>/dev/null | awk '{print $1}')
      if [ -n "$unpushed" ] && [ "$unpushed" -gt 0 ]; then
        has_unpushed=true
      fi
    fi

    status_indicator=""
    if [ "$has_staged" = true ]; then
      status_indicator="${status_indicator}"
    fi
    if [ "$has_modified" = true ]; then
      status_indicator="${status_indicator}"
    fi
    if [ "$has_untracked" = true ]; then
      status_indicator="${status_indicator}"
    fi
    if [ "$has_unpushed" = true ]; then
      status_indicator="${status_indicator}"
    fi

    if [ -n "$status_indicator" ]; then
      git_info=" ${git_branch} ${status_indicator}"
    else
      git_info=" ${git_branch}"
    fi
  fi
fi

if [ -n "$git_info" ]; then
  components+=("$git_info")
fi

# Add context window percentage
context_info=""
if [ -n "$remaining" ] && [ "$remaining" != "null" ] && [ "$remaining" != "" ]; then
  remaining_int=${remaining%.*}
  context_info=" ${remaining}%"
elif [ -n "$used" ] && [ "$used" != "null" ] && [ "$used" != "" ]; then
  context_info=" ${used}%"
fi

if [ -n "$context_info" ]; then
  components+=("$context_info")
fi

# Add token usage
if [ "$current_usage" != "null" ] && [ -n "$current_usage" ]; then
  input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0' 2>/dev/null)
  output_tokens=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0' 2>/dev/null)

  if [ "$input_tokens" -gt 0 ] || [ "$output_tokens" -gt 0 ]; then
    format_number() {
      local num=$1
      if [ "$num" -ge 1000000 ]; then
        echo "$((num / 1000000))M"
      elif [ "$num" -ge 1000 ]; then
        echo "$((num / 1000))k"
      else
        echo "$num"
      fi
    }

    input_display=$(format_number "$input_tokens")
    output_display=$(format_number "$output_tokens")
    components+=(" ${input_display}/${output_display}")
  fi
fi

# Add battery status for macOS
if command -v pmset &> /dev/null; then
  battery_percent=$(pmset -g batt | grep -Eo '\d+%' | sed 's/%//')
  battery_status=$(pmset -g batt | grep -o 'charging'; pmset -g batt | grep -o 'discharging')

  if [ -n "$battery_percent" ]; then
    if [ "$battery_status" = "charging" ]; then
      battery_icon=""
    elif [ "$battery_percent" -lt 20 ]; then
      battery_icon=""
    elif [ "$battery_percent" -lt 50 ]; then
      battery_icon=""
    elif [ "$battery_percent" -lt 80 ]; then
      battery_icon=""
    else
      battery_icon=""
    fi
    components+=("${battery_icon} ${battery_percent}%")
  fi
fi

# Add Node.js version
node_info=""
if command -v node &> /dev/null; then
  node_version=$(node --version 2>/dev/null)
  if [ -n "$node_version" ]; then
    node_info="⬢ ${node_version}"
  fi
fi

if [ -n "$node_info" ]; then
  components+=("$node_info")
fi

# Add directory path
if [ -n "$current_dir" ] && [ -d "$current_dir" ]; then
  if [[ "$current_dir" == "$HOME"* ]]; then
    display_path="~${current_dir#$HOME}"
  else
    display_path="$current_dir"
  fi
  components+=(" ${display_path}")
fi

# Join components with separator
if [ ${#components[@]} -gt 0 ]; then
  status_line=$(printf "%s │ " "${components[@]}")
  status_line="${status_line% │ }"
fi

# Output the status line
if [ -n "$status_line" ]; then
  printf "%s" "$status_line"
else
  printf "Claude Code"
fi

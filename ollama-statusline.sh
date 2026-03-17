#!/bin/bash

# Ollama macOS Status Line Script
# Shows: model, project, remaining usage, and status indicator

# Color codes for terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Ollama is running
check_ollama_status() {
    if ollama ps &>/dev/null; then
        echo "●"  # Green dot (running)
        return 0
    else
        echo "○"  # Red dot (stopped)
        return 1
    fi
}

# Get current model from ollama ps
get_current_model() {
    local model=$(ollama ps 2>/dev/null | awk 'NR==2 {print $1}')
    if [ -z "$model" ]; then
        echo "—"
    else
        # Truncate to 20 chars
        echo "$model" | cut -c1-20
    fi
}

# Get project (using current directory name as project identifier)
get_project() {
    basename "$PWD"
}

# Get active tokens/sec if generating
get_tokens_per_sec() {
    # Ollama doesn't expose live tok/s via ps, so we show "active" if model is loaded
    local has_model=$(ollama ps 2>/dev/null | awk 'NR>1 {print $1}' | head -1)
    if [ -n "$has_model" ]; then
        echo "idle"
    else
        echo "stopped"
    fi
}

# Main status line output
statusline() {
    local status_dot=$(check_ollama_status)
    local model=$(get_current_model)
    local project=$(get_project)
    local state=$(get_tokens_per_sec)

    # Format: ● ollama · {model} · {state}
    printf "%s ollama  ·  %s  ·  %s" "$status_dot" "$model" "$state"
}

statusline

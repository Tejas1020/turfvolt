#!/bin/bash
# SwiftBar plugin for Ollama status - refreshes every 1 second
# <bitbar.title>Ollama Status</bitbar.title>
# <bitbar.version>1.0</bitbar.version>
# <bitbar.author>Claude</bitbar.author>

# Check if Ollama is running
if ollama ps &>/dev/null; then
    STATUS_ICON="●"
    STATUS_COLOR="green"
else
    STATUS_ICON="○"
    STATUS_COLOR="red"
fi

# Get current model
MODEL=$(ollama ps 2>/dev/null | awk 'NR==2 {print $1}')
if [ -z "$MODEL" ]; then
    MODEL="—"
fi

# Truncate model name to 20 chars
MODEL=$(echo "$MODEL" | cut -c1-20)

# Get project from current directory
PROJECT=$(basename "$PWD")

# Output format: ● ollama · {model} · {project}
echo "$STATUS_ICON ollama  ·  $MODEL  ·  $PROJECT"
echo "---"
if [ "$STATUS_COLOR" = "green" ]; then
    echo "Status: Working|color=green"
else
    echo "Status: Not Working|color=red"
fi
echo "Model: $MODEL"
echo "Project: $PROJECT"
echo "---"
echo "Refresh | refresh=true"

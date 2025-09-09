#!/usr/bin/env bash
# Simple wrapper to stream a prompt to the Groq API.
# Usage: ./groqcli.sh "Your prompt here"
# Requires GROQ_API_KEY environment variable set.

ENDPOINT_URL="https://api.groq.com/openai/v1/chat/completions"
MODEL="openai/gpt-oss-20b"
PROMPT="$*"

# Escape special characters for JSON (handles ", \, /, \b, \f, \n, \r, \t)
escape_json() {
    local s="$1"
    s="${s//\\/\\\\}"   # \
    s="${s//\"/\\\"}"   # "
    s="${s//\//\\/}"    # /
    s="${s//$'\b'/\\b}" # backspace
    s="${s//$'\f'/\\f}" # formfeed
    s="${s//$'\n'/\\n}" # newline
    s="${s//$'\r'/\\r}" # carriage return
    s="${s//$'\t'/\\t}" # tab
    echo "$s"
}

if [[ -z "$PROMPT" ]]; then
    echo "Usage: $0 \"Your prompt here\""
    exit 1
fi

if [[ -z "$GROQ_API_KEY" ]]; then
    echo "Error: GROQ_API_KEY environment variable not set."
    exit 1
fi

ESCAPED_PROMPT=$(escape_json "$PROMPT")

read -r -d '' PAYLOAD <<EOF
{
    "messages": [
        {
            "role": "system",
            "content": "answer in the least amount of words possible. if you're asked a CLI command, LINUX command or other technical queries, respond with the command only."
        },
        {"role": "user", "content": "$ESCAPED_PROMPT"}
    ],
    "model": "$MODEL",
    "temperature": 1,
    "max_completion_tokens": 8192,
    "top_p": 1,
    "stream": true,
    "reasoning_effort": "medium",
    "stop": null
}
EOF

curl --fail --no-buffer -sS -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $GROQ_API_KEY" \
    -d "$PAYLOAD" \
    "$ENDPOINT_URL" | \
    grep -o '{.*}' | \
    jq --unbuffered -r -j '.choices[].delta.content // empty'

if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    echo "Error: Failed to connect to Groq API or invalid response." >&2
    exit 2
fi
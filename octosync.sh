#!/bin/bash

# Welcome to OctoSync: The Ultimate Chaos Coordinator 🚀
echo "🐙 OctoSync engaged! Preparing the absurd synchronization of all things silly..."

# Config & Log Files
CONFIG_FILE="silly_config.yaml"
LOG_FILE="/var/log/octosync.log"
WHITELISTED_PINGS=("8.8.8.8" "1.1.1.1")  # Example whitelist (Google & Cloudflare DNS)

# Ensure necessary dependencies exist
if ! command -v jq >/dev/null; then
    echo "⚠️  'jq' not found. Please install it to parse JSON." >&2
    exit 1
fi
if ! command -v yq >/dev/null; then
    echo "⚠️  'yq' not found. Please install it to parse YAML." >&2
    exit 1
fi

# Load chaos settings from YAML
CHAOS_LEVEL=$(yq e '.chaos_level' "$CONFIG_FILE")
CHARACTERS=($(yq e '.characters[]' "$CONFIG_FILE"))
SOUND_EFFECTS=$(yq e '.sound_effects.enabled' "$CONFIG_FILE")
VOLUME=$(yq e '.sound_effects.volume' "$CONFIG_FILE")

# Function to randomly throw in Chuckle Questions
random_chuckle_question() {
    QUESTION=$(jq -r ".morning_questions | .[\$(shuf -i 0-9 -n 1)].question" chuckle_questions.json)
    echo "🎤 Chuckle Query: $QUESTION"
}

# Function to whitelist pings
ping_whitelist() {
    for IP in "${WHITELISTED_PINGS[@]}"; do
        ping -c 1 "$IP" >/dev/null 2>&1 && echo "✅ Whitelisted ping successful to $IP"
    done
}

# Function to launch subprocesses
launch_services() {
    echo "🚀 Starting OctoSync services..."
    ./api_capsule_monitor.sh &
    ./crimson_controller.sh &
    ./fraglewatch.sh &
    ./jaxo_the_jester.sh &
    ./ping_blocker.sh &
}

# Function to randomize chaos effects based on config
trigger_chaos() {
    case "$CHAOS_LEVEL" in
        "mild") echo "🌿 A gentle breeze of silliness blows through OctoSync..." ;;
        "silly") random_chuckle_question ;;
        "bananas") echo "🍌 CHAOS UNLEASHED! All characters online!" ; launch_services ;;
    esac
}

# Run main event loop
while true; do
    echo "🔄 OctoSync heartbeat..."
    trigger_chaos
    ping_whitelist
    sleep 10  # Adjust frequency of checks

done

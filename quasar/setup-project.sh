#!/bin/bash

REQUIRED_NODE_VERSION=14

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Get the current working directory
CURRENT_DIR="$(pwd)"

echo "Script directory: $SCRIPT_DIR"
echo "Current working directory: $CURRENT_DIR"

# Function to validate project name
validate_project_name() {
    local NAME="$1"
    local LENGTH=${#NAME}

    # Check if name is empty
    if [ $LENGTH -eq 0 ]; then
        echo "Error: Package name cannot be empty."
        return 1
    fi

    # Check if name exceeds 214 characters
    if [ $LENGTH -gt 214 ]; then
        echo "Error: Package name cannot exceed 214 characters."
        return 1
    fi

    # Check if name contains uppercase letters
    if [[ "$NAME" =~ [A-Z] ]]; then
        echo "Error: Package name must be lowercase."
        return 1
    fi

    # Check if name starts with . or _
    if [[ "$NAME" =~ ^[._] ]]; then
        echo "Error: Package name cannot start with . or _"
        return 1
    fi

    # Check for spaces and invalid characters
    if [[ "$NAME" =~ [[:space:]\~\)\(\'\!\*] ]]; then
        echo "Error: Package name contains invalid characters (space, ~, ), (, ', !, or *)."
        return 1
    fi

    # Check for non-URL-safe characters
    if [[ "$NAME" =~ [^a-z0-9\-] ]]; then
        echo "Error: Package name contains non-URL-safe characters."
        return 1
    fi

    # Check against reserved names and core modules
    local RESERVED_NAMES=($(node -e "console.log(require('module').builtinModules.join(' '))"))
    RESERVED_NAMES+=("node_modules" "favicon.ico")
    for RESERVED in "${RESERVED_NAMES[@]}"; do
        if [ "$NAME" = "$RESERVED" ]; then
            echo "Error: '$NAME' is a reserved name or core module."
            return 1
        fi
    done

    echo "Package name '$NAME' is valid."
    return 0
}

check_node_version() {
    if ! command -v node &> /dev/null; then
        echo "Error: Node.js is not installed or not in PATH."
        exit 1
    fi

    local NODE_VERSION=$(node -v | cut -d 'v' -f 2)
    local MAJOR_VERSION=$(echo $NODE_VERSION | cut -d '.' -f 1)

    if [ "$MAJOR_VERSION" -lt $REQUIRED_NODE_VERSION ]; then
        echo "Error: Node.js $REQUIRED_NODE_VERSION or above is required. Current version: $NODE_VERSION"
        exit 1
    fi

    echo "Node.js version $NODE_VERSION is installed."
}

check_node_version

# Main loop
while true; do
    read -p "Enter project name (must start with a letter, no spaces or special characters): " PROJECT_NAME
    if validate_project_name "$PROJECT_NAME"; then
        echo "TypeScript project '$PROJECT_NAME' created successfully."
        break
    else
        echo "Invalid project name. Please try again."
    fi
done
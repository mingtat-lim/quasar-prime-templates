#!/bin/bash

REQUIRED_NODE_VERSION=14

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Get the current working directory
CURRENT_DIR="$(pwd)"

# echo "Script directory: $SCRIPT_DIR"
# echo "Current working directory: $CURRENT_DIR"

# default to false, set --debug command line arguments to debug
DEBUG=false

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --debug) DEBUG=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Debug output
if $DEBUG; then
    echo "Debug mode: ON"
    echo "Script directory: $SCRIPT_DIR"
    echo "Current working directory: $CURRENT_DIR"
fi

# Function to display the menu
show_menu() {
    echo "Please select an option:"
    echo "1) List files"
    echo "2) Show current date and time"
    echo "3) Check disk usage"
    echo "4) Create a new TypeScript project"
    echo "5) Create a Quasar PWA project"
    echo "q) Exit"
}

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

# Function to create a TypeScript project
create_typescript_project() {
    while true; do
    read -p "Enter project name (must start with a letter, no spaces or special characters): " PROJECT_NAME
    if validate_project_name "$PROJECT_NAME"; then

        "$SCRIPT_DIR/typescript/setup-project.sh" $PROJECT_NAME
        
        echo "TypeScript project '$PROJECT_NAME' created successfully."

        exit 0
        break
    else
        echo "Invalid project name. Please try again."
    fi
    done
}

# Function to create a Quasar PWA project
create_quasar_pwa_project() {
    while true; do
        read -p "Enter project name (must start with a letter, can contain hyphens): " project_name
        if validate_project_name "$project_name"; then
            echo "Creating Quasar PWA project '$project_name'..."
            mkdir "$project_name"
            cd "$project_name"
            npm init quasar

            echo "Quasar project initialization complete."
            echo "To run your project, navigate to the project directory and use 'quasar dev'."
            break
        else
            echo "Invalid project name. Please try again."
        fi
    done
}

# Function to execute the selected option
execute_option() {
    case $1 in
        1)
            echo "Listing files:"
            ls -l
            ;;
        2)
            echo "Current date and time:"
            date
            ;;
        3)
            echo "Disk usage:"
            df -h
            ;;
        4)
            echo "Creating a new TypeScript project:"
            create_typescript_project
            ;;
        5)
            echo "Creating a new Quasar PWA project:"
            create_quasar_pwa_project
            ;;
        q|Q)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice (1-5 or q to exit): " choice
    echo ""
    execute_option $choice
    echo ""
done
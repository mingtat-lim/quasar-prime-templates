#!/bin/bash

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
    if [[ $1 =~ ^[a-zA-Z][a-zA-Z0-9-]*$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to create a TypeScript project
create_typescript_project() {
    while true; do
        read -p "Enter project name (must start with a letter, no spaces or special characters): " project_name
        if validate_project_name "$project_name"; then
            mkdir "$project_name"
            cd "$project_name"
            npm init -y
            npm install --save-dev typescript @types/node
            npx tsc --init
            echo "console.log('Hello, TypeScript!');" > src/index.ts
            echo "{
  \"scripts\": {
    \"start\": \"tsc && node dist/index.js\"
  }
}" > package.json
            echo "TypeScript project '$project_name' created successfully."
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
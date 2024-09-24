#!/bin/bash

# Check if the parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <projectName>"
    exit 1
fi

# Check if the parameter contains spaces
if [[ "$1" == *" "* ]]; then
    echo "Error: Project name cannot contain spaces"
    exit 1
fi

# Assign the parameter to an uppercase variable with underscores
PROJECT_NAME="$1"

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Get the current working directory
CURRENT_DIR="$(pwd)"

echo "Script directory: $SCRIPT_DIR"
echo "Current working directory: $CURRENT_DIR"

# Create a new directory for the project
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create a src directory
mkdir src

# copy all tempakles to the working folders
cp -R "${SCRIPT_DIR}/templates/" .

# # Create a VS Code configuration file
# cat > .gitignore <<- EOM
# node_modules
# dist
# .DS_Store
# EOM


# Get the Git email
GIT_NAME=$(git config --get user.name)

# Get the Git email
GIT_EMAIL=$(git config --get user.email)


git init

# Initialize a new TypeScript project with a specific version
npm init es6 -y
npm install --save-dev typescript@5.5.4 @types/node

npm pkg set name="$PROJECT_NAME"
npm pkg set main="node dist/index.js"
npm pkg set author.name="${GIT_NAME}"
npm pkg set author.email="${GIT_EMAIL}"
npm pkg set author.url="https://github.com/${GIT_NAME}/$PROJECT_NAME"

# npx tsc --init

# Configure TypeScript for ESM
# echo "{
#   \"compilerOptions\": {
#     \"module\": \"ESNext\",
#     \"target\": \"ESNext\",
#     \"moduleResolution\": \"node\",
#     \"esModuleInterop\": true,
#     \"resolveJsonModule\": true,
#     \"outDir\": \"dist\",
#     \"strictNullChecks\": true,
#   },
#   \"include\": [\"src/**/*\"],
#   \"exclude\": [\"node_modules\", \"dist\"]
# }" > tsconfig.json
# cat > tsconfig.json <<- EOM
# {
#     "compilerOptions": {
#         "module": "ESNext",
#         "target": "ESNext",
#         "moduleResolution": "node",
#         "esModuleInterop": true,
#         "resolveJsonModule": true,
#         "outDir": "dist",
#         "strictNullChecks": true,
#         "skipLibCheck": true
#     },
#     "include": ["src/**/*"],
#     "exclude": ["node_modules", "dist"]
# }
# EOM

# Install ESLint, TypeScript ESLint, and Prettier
npm install --save-dev eslint @eslint/js @types/eslint__js typescript-eslint prettier eslint-config-prettier eslint-plugin-prettier
# npm install --save-dev eslint @eslint/js @types/eslint__js typescript-eslint

# Initialize ESLint configuration with default values
# npx eslint --init --use-default
# cat > eslint.config.mjs <<- EOM
# // import globals from 'globals';
# import pluginJs from '@eslint/js';
# import tseslint from 'typescript-eslint';

# export default [
#     // { languageOptions: { globals: globals.browser } },
#     pluginJs.configs.recommended,
#     // ...tseslint.configs.recommended,

#     ...tseslint.configs.strictTypeChecked,
#     ...tseslint.configs.stylisticTypeChecked,
#     {
#         files: ['**/*.{js,mjs,cjs,ts}'],
#         ignores: ['dist/**/*', 'eslint.config.mjs', 'prettier.config.mjs'],
#         languageOptions: {
#             parserOptions: {
#                 project: true,
#                 tsconfigRootDir: import.meta.dirname,
#             },
#         },
#     },
# ];

# EOM

# # Create a basic TypeScript file
# echo "console.log('Hello, TypeScript!');" > src/index.ts

# Add script commands to package.json
cat package.json | jq '.scripts += {
    "checkin": "git add . && git commit -m \"daily commit\" -S && git push",
    "lint": "eslint \"src/**/*.ts\"",
    "lint-fix": "eslint --fix \"src/**/*.ts\"",
    "format": "prettier --write \"**/*.{ts,js,mjs,json,css,scss,md}\"",
    "build": "tsc",
    "start": "node dist/index.js",
    "watch": "tsc -w"
}' > temp.json && mv temp.json package.json

# set type to module, not tested
# npm pkg set type="module"

# Create a Prettier configuration file
# echo "{
#   \"singleQuote\": true,
#   \"tabWidth\": 4,
#   \"printWidth\": 120
# }" > .prettierrc
# cat > prettier.config.mjs <<- EOM
# export default {
#     singleQuote: true,
#     trailingComma: 'all',
#     tabWidth: 4,
#     printWidth: 120,
# };
# EOM

# # Create a VS Code configuration file
# cat > .editorconfig <<- EOM
# root = true

# [*]
# charset = utf-8
# indent_style = space
# indent_size = 4
# end_of_line = lf
# insert_final_newline = true
# trim_trailing_whitespace = true
# EOM

# format source code...
npm run format

# checkin for the first time
git add . && git commit -S -m 'initial checkin'

echo "TypeScript project '$PROJECT_NAME' initialized with ESM support, ESLint, Prettier, and script commands added successfully."
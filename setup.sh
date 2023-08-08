#!/bin/bash

# Input string for API_REPO_NAME
read -p "Enter the name of the API repository: " repo_name

# Input string for API_ENV_PREFIX
read -p "Enter the environment variable prefix: " env_prefix

# Replace all instances of API_REPO_NAME and API_ENV_PREFIX
find . -type f -not -path "./.git/*" -not -name "*.sh" -not -name "SETUP.md" -exec sed -i.bak "s/API_REPO_NAME/${repo_name}/g" {} +
find . -type f -not -path "./.git/*" -not -name "*.sh" -not -name "SETUP.md" -exec sed -i.bak "s/API_ENV_PREFIX/${env_prefix}/g" {} +

# Remove all .bak files
find . -type f -name "*.bak" -exec rm {} +

echo "Setup complete!"
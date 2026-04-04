#!/usr/bin/env bash

# Prompt user for the project directory
read -r -p "Enter the project directory (start with 'work/<company>', 'personal', or 'temp'): " input_dir

# validate that input_dir starts with 'work', 'personal', or 'temp'
if [[ ! $input_dir =~ ^(work|personal|temp) ]]; then
  echo "Invalid project directory. Please start with 'work/*', 'personal', or 'temp'."
  exit 1
fi

project_dir=$HOME/dev/$input_dir

# Create the project directory if it doesn't exist
mkdir -p "$project_dir"

# Prompt user for the Git remote URL (optional)
read -r -p "Enter the Git remote URL (press Enter to skip): " git_url

# If Git remote URL is provided, clone the repository
if [ -n "$git_url" ]; then
  git clone "$git_url" "$project_dir"
fi

echo "Project setup complete."

"$HOME"/.local/bin/tmux-sessionizer.sh "$project_dir"

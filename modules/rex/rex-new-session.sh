#!/usr/bin/env bash
set -eu

read -r -p "Enter the project directory (start with 'work/<company>', 'personal', or 'temp'): " input_dir

if [[ ! $input_dir =~ ^(work|personal|temp) ]]; then
  echo "Invalid project directory. Please start with 'work/*', 'personal', or 'temp'."
  exit 1
fi

project_dir=$HOME/dev/$input_dir
mkdir -p "$project_dir"

read -r -p "Enter the Git remote URL (press Enter to skip): " git_url

if [[ -n $git_url ]]; then
  git clone "$git_url" "$project_dir"
fi

exec rex-sessionizer "$project_dir"

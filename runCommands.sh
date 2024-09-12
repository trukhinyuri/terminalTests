#!/bin/bash

# Check if the commands.txt file exists
if [ ! -f commands.txt ]; then
  echo "File commands.txt not found!"
  exit 1
fi

echo "Reading commands from commands.txt..."

# Read commands from the file and execute them one by one
while IFS= read -r command
do
  # Trim leading/trailing whitespace
  command=$(echo "$command" | xargs)

  # Debugging: Check if the command is read correctly
  echo "Read command: '$command'"

  # Skip empty lines or lines containing "No data"
  if [[ -z "$command" || "$command" == *"No data"* ]]; then
    echo "Skipping invalid or empty command: '$command'"
    continue
  fi

  echo "Executing command: '$command'"

  # Execute the command and display stdout and stderr
  eval "$command" 2>&1

  # Check the result of the last command
  if [ $? -ne 0 ]; then
    echo "Error executing command: '$command'"
  fi
done < commands.txt

echo "Finished executing all commands."
#!/bin/bash

# Function to execute a command and display its output, error, and exit status
run_command() {
  echo "Executing: $1"
  eval "$1" 2>&1  # Capture both stdout and stderr
  local status=$?
  echo "Exit status: $status"
  echo "-------------------------------------------------"
}

# List of commands that will produce different errors
commands=(
  "cd nonexistent-directory"                   # Directory not found
  "ls --invalid-flag"                          # Invalid flag
  "pip install nonexistent-package"            # Package not found
  "git commit --no-message"                    # Missing commit message
  "python invalid_script.py"                   # File not found
  "npm install invalid-package"                # Package not found
  "docker run nonexistent-image"               # Image not found
  "mvn nonexistent-command"                    # Unknown Maven command
  "rm nonexistent-file"                        # File not found
  "touch /root/testfile"                       # Permission denied
  "mkdir /system/testdir"                      # Permission denied
  "curl nonexistent-url"                       # URL not found
  "chmod 777 nonexistent-file"                 # File not found
  "ssh nonexistent-host"                       # Host unreachable
  "ping nonexistent-host"                      # Host unreachable
  "scp nonexistent-file user@host:/path"       # File not found
  "ps -p nonexistent-pid"                      # Process not found
  "find / invalid-file"                        # File not found
  "tail -f nonexistent-file"                   # File not found
  "git push origin nonexistent-branch"         # Branch not found
  "apt-get install nonexistent-package"        # Package not found
  "brew install nonexistent-formula"           # Formula not found
  "docker-compose up invalid-service"          # Service not found
  "go run nonexistent.go"                      # File not found
  "terraform apply nonexistent-file"           # File not found
  "java -invalid-option"                       # Invalid Java option
  "helm install nonexistent-chart"             # Chart not found
  "yarn install nonexistent-package"           # Package not found
  "pytest nonexistent-test"                    # Test not found
)

# Iterate through the list of commands and run each one
for cmd in "${commands[@]}"; do
  run_command "$cmd"
done

echo "All commands executed."
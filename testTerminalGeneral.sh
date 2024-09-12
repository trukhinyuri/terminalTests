#!/bin/bash

# Function to execute a command and display its output, error, and exit status
run_test() {
  echo "Test: $1"
  eval "$1" 2>&1  # Capture both stdout and stderr
  local status=$?
  if [ $status -eq 0 ]; then
    echo "Test Passed: $1"
  else
    echo "Test Failed (Exit Code: $status): $1"
  fi
  echo "-------------------------------------------------"
}

echo "Starting terminal functionality tests..."

# 1. File system tests
run_test "mkdir testdir && rmdir testdir"                      # Create and remove directory
run_test "touch testfile && ls testfile"                       # Create and list file
run_test "echo 'Test' > testfile && cat testfile"              # Write to and read from file
run_test "chmod 000 testfile && ls -l testfile"                # Change file permissions
run_test "rm testfile"                                         # Remove file

# 2. Network tests
run_test "ping -c 1 8.8.8.8"                                  # Ping a known server (Google DNS)
run_test "curl -I http://example.com"                          # Make HTTP request
run_test "wget http://example.com -O example.html"             # Download a file
run_test "rm example.html"                                     # Clean up downloaded file

# 3. Process tests
run_test "ps aux | grep bash"                                  # List bash processes
run_test "sleep 5 &"                                           # Start background process
run_test "jobs"                                                # List background jobs
run_test "kill %1"                                             # Kill background process

# 4. System resource tests
run_test "df -h"                                               # Check disk space
run_test "free -h"                                             # Check memory usage
run_test "uptime"                                              # Check system uptime

# 5. Environment variable tests
run_test "export TEST_VAR='Hello World' && echo \$TEST_VAR"     # Create and use environment variable
run_test "unset TEST_VAR"                                      # Unset environment variable

# 6. Archive and compression tests
run_test "tar -cvf testarchive.tar testdir"                    # Create tar archive
run_test "gzip testarchive.tar"                                # Compress archive
run_test "gunzip testarchive.tar.gz"                           # Decompress archive
run_test "rm testarchive.tar"                                  # Remove archive

# 7. Package manager tests (use with caution, adjust for your package manager)
run_test "apt-get update"                                      # Update package list (use for apt-based systems)
run_test "apt-get install -y sl"                               # Install package (sl train as an example)
run_test "sl"                                                  # Run the installed package (should see a steam train)
run_test "apt-get remove -y sl"                                # Uninstall the package

# 8. Compilation and scripting tests
run_test "gcc --version"                                       # Check if GCC is available
run_test "echo '#include <stdio.h>\nint main() { printf(\"Hello World\"); return 0; }' > test.c && gcc test.c -o test && ./test" # Compile and run C program
run_test "rm test test.c"                                      # Clean up C program
run_test "bash -c 'echo Hello from bash'"                      # Test Bash script

# 9. User and permission tests
run_test "id"                                                  # Check user ID and group
run_test "sudo -l"                                             # Check sudo privileges (requires password)

# 10. Error handling tests (expecting errors)
run_test "cd nonexistent-directory"                            # Test for directory not found
run_test "rm nonexistent-file"                                 # Test for file not found
run_test "ls --invalid-flag"                                   # Test for invalid flag
run_test "chmod 777 nonexistent-file"                          # Test for permission error

# Clean up created files and directories
run_test "rm -f testfile example.html testarchive.tar test"
run_test "rmdir testdir"

echo "All tests completed."
#!/bin/bash

# Array to store test names and execution times
declare -a test_names
declare -a test_times

# Function to run a command and measure its execution and output time with a progress bar
run_terminal_test() {
  command="$1"
  description="$2"
  total_lines="$3"
  echo "Running: $description"

  # Measure the time of the command's output (printing to terminal)
  START=$(date +%s.%N)

  # Temporary file to store command output
  temp_file=$(mktemp)
  eval "$command" > "$temp_file" &
  pid=$!

  # Progress bar
  while kill -0 $pid 2> /dev/null; do
    # Clear the screen and show progress
    clear
    echo "Test: $description"

    # Get the current progress
    progress=$(wc -l < "$temp_file")
    percentage=$(echo "scale=2; ($progress / $total_lines) * 100" | bc)
    bar_length=50
    filled_length=$(echo "scale=0; $bar_length * $progress / $total_lines" | bc)
    unfilled_length=$((bar_length - filled_length))

    # Print progress bar
    echo -n "Progress: ["
    printf "%${filled_length}s" | tr ' ' '#'
    printf "%${unfilled_length}s" | tr ' ' '-'
    echo -n "] ${percentage}% done"

    # Print test output (display last few lines of the file)
    tail -n 20 "$temp_file"

    sleep 1
  done
  # Final progress
  progress=$(wc -l < "$temp_file")
  percentage=$(echo "scale=2; ($progress / $total_lines) * 100" | bc)
  clear
  echo "Test: $description"
  echo -n "Progress: ["
  filled_length=$(echo "scale=0; $bar_length * $progress / $total_lines" | bc)
  unfilled_length=$((bar_length - filled_length))
  printf "%${filled_length}s" | tr ' ' '#'
  printf "%${unfilled_length}s" | tr ' ' '-'
  echo -n "] 100% done"
  echo
  tail -n 20 "$temp_file"

  END=$(date +%s.%N)

  # Calculate the execution time
  DURATION=$(echo "$END - $START" | bc)

  # Store the test name and duration for later summary
  test_names+=("$description")
  test_times+=("$DURATION")

  echo "Execution time for $description: $DURATION seconds"
  echo "---------------------------------------------"
}

# Function to simulate a simple FPS-like animation
fps_test() {
  description="$1"
  frames=$2
  frame_delay=$3

  echo "Running: $description with $frames frames"

  START=$(date +%s.%N)

  for i in $(seq 1 $frames); do
    clear
    echo "Frame $i of $frames"
    echo "███████████████████████████████████████████████"
    echo "███████████████████████████████████████████████"
    echo "███████████████████████████████████████████████"
    echo "███████████████████████████████████████████████"
    echo "███████████████████████████████████████████████"
    echo "███████████████████████████████████████████████"
    sleep $frame_delay
  done

  END=$(date +%s.%N)

  DURATION=$(echo "$END - $START" | bc)

  test_names+=("$description")
  test_times+=("$DURATION")

  # Calculate FPS
  FPS=$(echo "$frames / $DURATION" | bc -l)

  echo "Execution time for $description: $DURATION seconds"
  echo "Estimated FPS: $FPS"
  echo "---------------------------------------------"
}

# Function to simulate a simple 3D animation in the terminal
three_d_test() {
  description="$1"
  echo "Running: $description"

  START=$(date +%s.%N)

  frames=20
  for i in $(seq 1 $frames); do
    clear
    angle=$(echo "scale=2; $i * 360 / $frames" | bc)
    echo "3D Rotation Frame $i of $frames"
    echo "           o"
    echo "          /|\\"
    echo "         / | \\"
    echo "        /  |  \\"
    echo "       /   |   \\"
    echo "      /    |    \\"
    echo "     /     |     \\"
    echo "    /      |      \\"
    echo "   /       |       \\"
    echo "  o--------o"
    sleep 0.1
  done

  END=$(date +%s.%N)

  DURATION=$(echo "$END - $START" | bc)

  test_names+=("$description")
  test_times+=("$DURATION")

  echo "Execution time for $description: $DURATION seconds"
  echo "---------------------------------------------"
}

# Function to output graphs in terminal
graph_test() {
  description="$1"
  echo "Running: $description"

  START=$(date +%s.%N)

  data="10 20 30 40 50 60 70 80 90 100"
  max_value=$(echo "$data" | awk '{print max($0)}')
  scale=$(echo "scale=2; 10 / $max_value" | bc)

  for value in $data; do
    clear
    echo "Graph Test"
    echo -n "Value: $value "
    num_hashes=$(echo "scale=0; $value * $scale" | bc)
    printf "%${num_hashes}s" | tr ' ' '#'
    sleep 0.5
  done

  END=$(date +%s.%N)

  DURATION=$(echo "$END - $START" | bc)

  test_names+=("$description")
  test_times+=("$DURATION")

  echo "Execution time for $description: $DURATION seconds"
  echo "---------------------------------------------"
}

# Starting the tests
echo "Starting extended terminal performance tests..."

# 1. Test for rendering large amounts of text (scrolling performance)
run_terminal_test "yes 'Testing Terminal Performance' | head -n 1000000" \
  "Rendering large amounts of text (1,000,000 lines)" 1000000

# 2. Test for rendering colored text using ANSI escape sequences
commands=(
  "for i in {1..500000}; do echo -e \"\\033[31mThis is red\\033[0m\"; done"
  "for i in {1..500000}; do echo -e \"\\033[32mThis is green\\033[0m\"; done"
  "for i in {1..500000}; do echo -e \"\\033[33mThis is yellow\\033[0m\"; done"
)
descriptions=(
  "Rendering red colored text (500,000 lines)"
  "Rendering green colored text (500,000 lines)"
  "Rendering yellow colored text (500,000 lines)"
)
for i in "${!commands[@]}"; do
  run_terminal_test "${commands[$i]}" "${descriptions[$i]}" 500000
done

# 3. Test for input/output processing (simulating mass input and output of text)
run_terminal_test "for i in {1..2500000}; do echo Test Input; done" \
  "Input/output processing test (2,500,000 lines)" 2500000

# 4. Test for output of large files using cat (5GB of random data)
dd if=/dev/urandom of=largefile bs=1G count=5 > /dev/null 2>&1          # Generate a 5GB random file
run_terminal_test "cat largefile" \
  "Output large files with 'cat' (5GB random data)" 10000000
rm largefile

# 5. Test with "yes" command to check rendering of high-volume output
run_terminal_test "yes 'Heavy Load' | head -n 10000000" \
  "Rendering extremely high-volume output (10,000,000 lines)" 10000000

# 6. Test for handling long lines of text and scrolling
run_terminal_test "for i in {1..500000}; do echo \"This is a very long line that will test terminal scrolling performance. $(seq -s X 10000 | tr -d '[:digit:]')\"; done" \
  "Rendering long lines of text (500,000 long lines, 10,000 characters per line)" 500000

# 7. Test for clearing and re-rendering large output (screen refresh)
run_terminal_test "for i in {1..50000}; do echo \"Clearing Test\"; done; clear; for i in {1..500000}; do echo \"Re-rendering Test\"; done" \
  "Clearing and re-rendering terminal output (50,000 clears and 500,000 re-renders)" 550000

# 8. Test for processing multiple short commands quickly (terminal reactivity)
run_terminal_test "for i in {1..2500000}; do echo -n '.'; done" \
  "Processing multiple short commands quickly (2,500,000 dots)" 2500000

# 9. FPS Test: Simulate an animation by rendering frames with a delay
fps_test "FPS Test: Simulating terminal animation (200 frames)" 200 0.05

# 10. FPS Test: Simulate a faster animation to test frame updates
fps_test "FPS Test: Fast animation (100 frames)" 100 0.01

# 11. 3D Graphics Test
three_d_test "3D Graphics Test: Simple rotation"

# 12. Graph Output Speed Test
graph_test "Graph Output Speed Test: Plotting values"

# Final message
echo "All tests completed."
echo "---------------------------------------------"

# Displaying a summary of all tests
echo "Summary of Execution Times:"
printf "%-60s %s\n" "Test Description" "Execution Time (seconds)"
for i in "${!test_names[@]}"; do
  printf "%-60s %s\n" "${test_names[$i]}" "${test_times[$i]}"
done

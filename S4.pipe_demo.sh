#!/bin/bash
# Save as Spipe_demo.sh

PIPE_NAME="/tmp/demo_pipe"

# Cleanup any existing pipe
rm -f "$PIPE_NAME"

# Create named pipe
mkfifo "$PIPE_NAME"

echo "=== Named Pipe Demo ==="
echo "Open a new terminal and run: cat $PIPE_NAME"
echo "This terminal will send messages to the pipe."
echo "Press Ctrl+C when done."

# Send messages
count=1
while true; do
    echo "Message $count from sender ($(date))" > "$PIPE_NAME"
    echo "Sent message $count"
    count=$((count + 1))
    sleep 2
done

# Note: The cleanup below will only execute if you Ctrl+C
# Cleanup
rm -f "$PIPE_NAME"

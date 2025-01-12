#!/bin/bash
# Save as S5.pipe_demo2.sh

PIPE_NAME="/tmp/demo_pipe"
TIMEOUT=10  # Timeout in seconds for receiver

# Cleanup function to remove pipe and terminate processes
cleanup() {
    echo -e "\nCleaning up..."
    # Kill any background jobs
    jobs -p | xargs -r kill
    # Remove the named pipe
    rm -f "$PIPE_NAME"
    exit 0
}

# Set cleanup on exit or interrupt
trap cleanup EXIT SIGINT SIGTERM

# Remove any existing pipe
rm -f "$PIPE_NAME"

# Create a new named pipe
if ! mkfifo "$PIPE_NAME"; then
    echo "Error: Could not create named pipe at $PIPE_NAME"
    exit 1
fi

echo "=== Named Pipe Demo ==="
echo "Receiver will listen for messages for $TIMEOUT seconds."
echo "To send a message, open another terminal and use: echo 'Your message' > $PIPE_NAME"
echo "To stop the communication, send 'quit'."

# Start the receiver in the background
{
    while true; do
        # Read from the named pipe with a timeout
        if read -t $TIMEOUT message < "$PIPE_NAME"; then
            echo "Receiver got: $message"
            # Exit loop if the received message is "quit"
            if [ "$message" = "quit" ]; then
                echo "Quit signal received. Exiting receiver."
                break
            fi
        else
            # Timeout message if no message is received within TIMEOUT
            echo "Receiver timeout: No message received in the last $TIMEOUT seconds."
            break
        fi
    done
} &

# Get the background receiver process's PID
RECEIVER_PID=$!

# Allow the receiver a moment to start
sleep 1

# Sender: Simulate sending 5 messages
for i in {1..5}; do
    # Check if the receiver is still running
    if ! kill -0 $RECEIVER_PID 2>/dev/null; then
        echo "Receiver has exited. Stopping sender."
        break
    fi

    echo "Sending message $i..."
    if ! echo "Message $i at $(date)" > "$PIPE_NAME"; then
        echo "Error: Failed to send message $i"
        break
    fi
    echo "Sent message $i"
    sleep 2
done

# Wait for the receiver to complete
wait $RECEIVER_PID

echo "Demo completed successfully."
exit 0

#!/bin/bash
# Save as S2.process_demo.sh

# Create a background task
create_background_task() {
    local id=$1
    while true; do
        echo "[Task $id] $(date): Running..." >> task_$id.log
        sleep 5
    done
}

echo "=== Starting Background Tasks ==="
# Start 3 background tasks
for i in {1..3}; do
    create_background_task $i &
    echo "Started task $i with PID $!"
done

echo -e "\n=== Process Status ==="
ps aux | grep "[c]reate_background_task"

echo -e "\n=== Using jobs command ==="
jobs

echo "Tasks are logging to task_*.log files"
echo "Press Enter to stop all tasks..."
read

# Cleanup
pkill -f "create_background_task"
rm -f task_*.log

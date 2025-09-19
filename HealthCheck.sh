#!/bin/bash

CPU_THRESHOLD=10
MEMORY_THRESHOLD=10
DISK_THRESHOLD=10

LOG_FILE="system_health.log"

# Get system stats
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//')

ALERTS=""

# Check CPU
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    ALERTS+="High CPU usage detected: ${CPU_USAGE}%\n"
fi

# Check Memory
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    ALERTS+="High Memory usage detected: ${MEMORY_USAGE}%\n"
fi

# Check Disk
if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then
    ALERTS+="Low Disk Space: ${DISK_USAGE}% used\n"
fi

# Log results
if [ -n "$ALERTS" ]; then
    echo -e "[ALERT] $(date):\n$ALERTS" | tee -a "$LOG_FILE"
else
    echo "System Health: OK"
fi

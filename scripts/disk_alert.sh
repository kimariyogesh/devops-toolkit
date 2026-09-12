#!/bin/bash

# ============================================
# disk_alert.sh — Disk Usage Monitor
# Usage: ./disk_alert.sh <threshold>
# Example: ./disk_alert.sh 80
# ============================================

set -euo pipefail

# --- Config ---
THRESHOLD=${1:-80}           # use argument if provided, default to 80
LOG_FILE="/tmp/disk_alert.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# --- Functions ---
log_message() {
    local LEVEL=$1
    local MESSAGE=$2
    echo "[$DATE] [$LEVEL] $MESSAGE" | tee -a $LOG_FILE
}

check_disk() {
    local MOUNT=$1
    local USAGE=$(df -h $MOUNT | tail -1 | awk '{print $5}' | tr -d '%')

    if [ -z "$USAGE" ]; then
        log_message "ERROR" "Could not get disk usage for $MOUNT"
        return 1
    fi

    if [ $USAGE -gt $THRESHOLD ]; then
        log_message "ALERT" "Disk usage on $MOUNT is ${USAGE}% (threshold: ${THRESHOLD}%)"
        return 1
    else
        log_message "OK" "Disk usage on $MOUNT is ${USAGE}%"
        return 0
    fi
}

# --- Main ---
log_message "INFO" "Starting disk check (threshold: ${THRESHOLD}%)"

# Check multiple mount points
for MOUNT in / /tmp; do
    check_disk "$MOUNT"
done

EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    log_message "INFO" "Disk check completed with warnings"
    exit 1
else
    log_message "INFO" "Disk check completed successfully"
    exit 0
fi
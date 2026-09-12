#!/bin/bash
set -euo pipefail

# ============================================
# log_parser.sh — Production Log Analyser
# Usage: ./log_parser.sh <logfile> [error|warn|info]
# Example: ./log_parser.sh /tmp/disk_alert.log error
# ============================================

LOG_FILE="${1:-}"
FILTER="${2:-all}"
REPORT_FILE="/tmp/log_report.txt"


# --logger--
log() {
    local LEVEL=$1; shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$LEVEL] $*"
}

# --error handler--
error_exit() {
    log "ERROR " "$1" >&2
    exit 1
}

# --cleanup--
cleanup() {
    log "INFO" "Parser finished report at: $REPORT_FILE"
}

# Automatic cleanup mechanism
trap cleanup EXIT

# --VALIDATE INPUT--
[ -z "$LOG_FILE" ] && error_exit "No log file specified. Usage: $0 <logfile> [filter]"
[ -f "$LOG_FILE" ] || error_exit "Log file not found: $LOG_FILE"

log "INFO" "Parsing log file: $LOG_FILE"
log "INFO" "Filter: $FILTER"

# --Parse and report--
TOTAL=$(wc -l < "$LOG_FILE")
ERRORS=$(grep -c "\[ERROR\]" "$LOG_FILE" || true)
WARNS=$(grep -c "\[WARN\]" "$LOG_FILE" || true)
ALERTS=$(grep -c "\[ALERT\]" "$LOG_FILE" || true)
OKS=$(grep -c "\[OK\]"   "$LOG_FILE" || true)

cat > "$REPORT_FILE" << EOF
========================================
Log Analysis Report
========================================
File     : $LOG_FILE
Analysed : $(date)
----------------------------------------
Total lines : $TOTAL
OK          : $OKS
Alerts      : $ALERTS
Warnings    : $WARNS
Errors      : $ERRORS
----------------------------------------
EOF

# --- Apply filter ---
if [ "$FILTER" = "all" ]; then
    echo "--- All entries ---" >> "$REPORT_FILE"
    cat "$LOG_FILE" >> "$REPORT_FILE"
else
    FILTER_UPPER=$(echo "$FILTER" | tr '[:lower:]' '[:upper:]')
    echo "--- Filtered: $FILTER_UPPER ---" >> "$REPORT_FILE"
    grep "\[$FILTER_UPPER\]" "$LOG_FILE" >> "$REPORT_FILE" || true
fi

cat "$REPORT_FILE"
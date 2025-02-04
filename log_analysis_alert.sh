#!/bin/bash

LOG_FILE="/var/log/myapp/error.log"
ERROR_PATTERN="ERROR\|CRITICAL"
CONTEXT_LINES=3

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
	echo "Error: Log file $LOG_FILE not found!" >&2
	exit 1
else 
	echo "Log file: $LOG_FILE exists!"
fi

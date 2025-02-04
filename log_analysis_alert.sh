#!/bin/bash

LOG_FILE="/var/log/myapp/error.log"
ERROR_PATTERN="ERROR\|CRITICAL"
CONTEXT_LINES=3

EMAIL="$USER@$(hostname)"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
	echo "Error: Log file $LOG_FILE not found!" >&2
	exit 1
else 
	echo "Log file: $LOG_FILE exists!"
fi

# Search for errors with context lines
ERRORS=$(grep -C $CONTEXT_LINES "$ERROR_PATTERN" "$LOG_FILE")


if [ -n "$ERRORS" ]; then
	# Prepare alert message
	TIMESTAMP=$(date + "%Y-%m-%d %T")
	MESSAGE="[Alert $TIMESTAMP] Errors detected in $LOG_FILE:\n\n$ERRORS"

	# send email
	echo -e "$MESSAGE" | mail -s "System Alert: Log Errors Found" "$EMAIL"
fi


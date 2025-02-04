# log-analysis-and-alert
The script checks log files for specific error patterns and send alerts if found.

Functionality:
The script will check log files for specific error patterns and send alerts if found.
-------------------------------------------------------------------------------------
**Requirements:**

**Inputs:**

1)take a log file path
2)an error pattern like "ERROR" or "CRITICAL"
3)number of context lines around the error

**Outputs:**

1)Timestamped alerts with error context
2)alert or notification via e-mail (echo initially)

**Edge Cases:**
1)log file missing
2)permission issues
3)no new errors since last check

-------------------------------------------------------------------------------------
-Create a directory 'myapp' in '/var/log/' -->  `sudo mkdir /var/log/myapp`

-create an empty log file in the new directory --> `sudo touch /var/log/myapp/error.log`


**ADD CODE:**
---
`!#/bin/bash` 
(the shebang, it tells the system to use the Bash shell(/bin/bash) to run the script.)


`LOG_FILE="/var/log/myapp/error.log"`
-stores the path to the log file

`ERROR_PATTERN="ERROR\|CRITICAL"`
-defines a pattern to search for in the log file, either "ERROR" or "CRITICAL"

`CONTEXT_LINES=3`
-specifies how many extra lines (before and after) to show around each error, helping to provide context.


```
1 if [ ! -f "$LOG_FILE" ]; then
2 	  echo "Error: Log file $LOG_FILE not found!" >&2
3	  exit 1
4 else
5     echo "Log file: $LOG_FILE exists! Proceeding..."
6 fi
```
**lines:**
1. starts the condition/if-statement, **-f** checks if $LOG_FILE exists and is a file. **!**(NOT) negates the check, which means "if the file does NOT exist"
2. print a message, **>&2** redirects the output to stderr(error output), so errors are handled seperately from normal output.
3. **exit 1** stops the script with an exit status of 1, which signals an error.
4. if the condition isn't met then...
5. print a message that the file exists.(no exit status because we want to check but continue with the script)
6. end of if statement


 

# log-analysis-and-alert
The script checks log files for specific error patterns and send alerts if found.

Functionality:
The script will check log files for specific error patterns and send alerts if found.
-------------------------------------------------------------------------------------
**Requirements:**

**Inputs:**

1. take a log file path
2. an error pattern like "ERROR" or "CRITICAL"
3. number of context lines around the error

**Outputs:**

1. Timestamped alerts with error context
2. alert or notification via e-mail (echo initially)

**Edge Cases:**
1. log file missing
2. permission issues
3. no new errors since last check

-------------------------------------------------------------------------------------
-Create a directory 'myapp' in '/var/log/' -->  `sudo mkdir /var/log/myapp`

-create an empty log file in the new directory --> `sudo touch /var/log/myapp/error.log`


**Add Code:**
------------------------------------------------------------------------------------
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


**Capture errors with context:**

- use **grep -C**, `grep` searches for text patterns in a file, `-C` flag tells grep to include extra lines before and after each match depending on the value
- `$CONTEXT_LINES` is the number of surrounding lines (in this case **3**)
- `$ERROR_PATTERN` is the pattern to search for, so it looks for either `"ERROR"` or `"CRITICAL"`
- `"$LOG_FILE"` is the file to search in (/var/log/myapp/error.log)

The syntax of **grep -C**:

`grep -C <num> "pattern" <file>`

store in a variable `ERRORS=$()`so in my case:

`ERRORS=$(grep -C $CONTEXT_LINES "$ERROR_PATTERN" "$LOG_FILE")`

***Why this works:***
This way I store the errors instead of printing them immediately, alowing the next steps to decide what to do based on the results. Also, it includes context for better debugging by including 3 lines before and after the error line, which makes it easier to understand what caused the error.
grep is also fast and built-in feature, which makes it a good choice for scanning logs.

------------------------------------------------------------------------------------
**Check if the $ERRORS varialbe is not empty**

`if [ -n "$ERRORS" ]; then`
(i.e. if any errors were found in the log file)

- `[ ... ]` test command used to evaluate conditions
- `-n` Checks if a string contains text
- `"$ERRORS"` the variable storing the output from grep, if grep found errors, this will have text.


**Create a timestam to include in the alert**
`TIMESTAMP=$(date "+%Y-%m-%d %T")`

- `$(...)` captures the output of date and assigns it to TIMESTAMP
- `date` command generates the current date and time
- `"+%Y-%m-%d %T"` specifies a custom format

**Format an alert message with the timestamp, name of log file and errors found**
`MESSAGE="[Alert $TIMESTAMP] Errors detected in $LOG_FILE:\n\n$ERRORS"`
(constructs a detailed message alert)

- `MESSAGE=""` its all text, hence the "" quotation marks
- `[Alert $TIMESTAMP]` a label indicating this is an alert with the timestamp
- `\n\n` inserts two new lines
- `Errors detected in $LOG_FILE` shows which file the errors came from


 
**send notification containing alert message as an email**

First we need a variable to store EMAIL:
`EMAIL="$USER@$(hostname)"`

- `$USER` is a predifined variable in linux that stores the username of the user currently logged-in.
- `$(hostname)` is a command that retrieves the system's hostname.
- together we get an email address that works for local mail delivery, meaning messages sent to it will be delivered to the local system's inbox (/var/mail/$USER)


`echo -e "$MESSAGE" | mail -s "System Alert: Log Errors Found" "$EMAIL"`
- `echo` prints text to terminal or passes it to another command
- `-e` will enable the interpretation of **escape sequences** like `\n` for new lines, as we know **$MESSAGE** contains them.
- `|`(Pipe) redirects the output of `echo` into the `mail` command
- `mail` sends an email
- `-s "System Alert: Log Errors Found"` sets the email's **subject** to "System Alert: Log..."
- `"$EMAIL"` the recepients email

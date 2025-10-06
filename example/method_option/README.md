# Method option usage

This directory contains an example demonstrating how to use `option` for different option types in Magni.

## Prerequisites

You need build tools to build mruby. Please install a compiler in advance.
See: https://github.com/mruby/mruby/blob/master/doc/guides/compile.md

## Usage

Build the example:

```sh
rake
```

After building, you can run the command as follows:

### Example

```
$ ./method_option
Usage:
  MethodOptionApp [command]

Commands:
  string       demonstrate string type options
  numeric      demonstrate numeric type options
  boolean      demonstrate boolean type options
  flag         demonstrate flag type options
  repeatable   demonstrate repeatable options
  display_name demonstrate display_name option
  banner       demonstrate banner option
  required     demonstrate required options
  default      demonstrate default options
  help         show this message

Options:
  -h, --help                        show this message and exit

# String type options
$ ./method_option string --help
Usage:
  MethodOptionApp string

Options:
  -n, --name string                 your name
  -m, --message string              greeting message
  -h, --help                        show this message and exit

$ ./method_option string --name Alice --message "Hi"
Hi, Alice!

$ ./method_option string
Hello, World!

# Numeric type options
$ ./method_option numeric --help
Usage:
  MethodOptionApp numeric

Options:
  -c, --count numeric               number to count to
  -s, --step numeric                step size
  -h, --help                        show this message and exit

$ ./method_option numeric --count 10 --step 2
2
4
6
8
10

# Boolean type options
$ ./method_option boolean --verbose --force
Processing...
Verbose mode: ON
Force mode: ON
  - Step 1: Initializing...
  - Step 2: Processing data...
  - Step 3: Finalizing...
Warning: Force mode enabled - skipping safety checks
Done!

# Flag type options
$ ./method_option flag --debug
Flag demonstration:
Debug mode: ON
Quiet mode: OFF
Debug: Starting flag command execution
Debug: Checking flag states
Debug: All checks completed
Flag command executed successfully!

$ ./method_option flag --quiet
Flag demonstration:
Debug mode: OFF
Quiet mode: ON

# Repeatable options
$ ./method_option repeatable -f file1.txt -f file2.txt --tag urgent --tag production
Files: file1.txt, file2.txt
Tags: urgent, production
Processing 2 files with 2 tags

# Display name options
$ ./method_option display_name --help
Usage:
  MethodOptionApp display_name

Options:
  -c, --CONFIG string               configuration file path
  -o, --DIRECTORY string            output directory
  -t, --COUNT numeric               maximum number of threads
  -h, --help                        show this message and exit

$ ./method_option display_name -c custom.conf -o /tmp/output -t 4
Configuration file: custom.conf
Output directory: /tmp/output
Max threads: 4

# Banner options
$ ./method_option banner --help
Usage:
  MethodOptionApp banner

Options:
  -o, --output FILE                 output file path
  -l, --logfile [LOGFILE]           log file (optional)
  -w, --workdir[=DIR]               working directory
  -h, --help                        show this message and exit

$ ./method_option banner --output result.txt --logfile app.log
Output file: result.txt
Log file: app.log
Working directory: /tmp

# Required options
$ ./method_option required --name John --email john@example.com
Name: John
Email: john@example.com
User registration completed!

$ ./method_option required
Error: --name is required

Usage:
  MethodOptionApp required

Options:
  -n, --name string                 user name (required)
  -e, --email string                email address (required)
  -h, --help                        show this message and exit

# Default options
$ ./method_option default
Connecting to localhost:8080
Timeout: 30 seconds
Connection established!

$ ./method_option default --host example.com --port 3000 --timeout 60
Connecting to example.com:3000
Timeout: 60 seconds
Connection established!
```

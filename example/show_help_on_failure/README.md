# Show help on failure usage

This directory contains an example demonstrating how to disable help display on command failure using `show_help_on_failure?` method.

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
$ ./show_help_on_failure
Usage:
  FailureExample [command]

Commands:
  process    process with required count option
  divide     divide two numbers
  help       show this message

Options:
  -c, --count numeric               number to process
  -h, --help                        show this message and exit

# Success case
$ ./show_help_on_failure process --count 5
Processing 5 items

$ ./show_help_on_failure divide 10 2
10 / 2 = 5.0

# Failure cases - notice no help is shown
$ ./show_help_on_failure process
Error: count option is required

$ ./show_help_on_failure divide 10 0
Error: Division by zero is not allowed
```

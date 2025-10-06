# Custom usage message

This directory contains an example demonstrating how to customize the usage message in Magni using the `usage` method.

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
$ ./custom_usage
CustomUsageApp is a demonstration tool for custom usage messages.

Usage:
  CustomUsageApp [options] <command> [arguments...]
  CustomUsageApp --version
  CustomUsageApp --help

Examples:
  CustomUsageApp greet John          # Greet someone by name
  CustomUsageApp count --num 5       # Count to a specific number
  CustomUsageApp status              # Show application status

Commands:
  count      count from 1 to specified number
  greet      greet someone by name
  status     show application status
  help       show this message

Options:
  -n, --num numeric                 number to count to
  -h, --help                        show this message and exit

# Command examples
$ ./custom_usage greet Alice
Hello, Alice! Welcome to CustomUsageApp.

$ ./custom_usage count --num 5
1
2
3
4
5

$ ./custom_usage status
Application: CustomUsageApp
Status: Running
This demonstrates custom usage formatting
```

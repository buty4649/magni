# Class option usage

This directory contains an example demonstrating how to use `class_option` to define global options available for all commands in Magni.

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
$ ./class_option
Usage:
  ClassOptionApp [command]

Commands:
  build      build the project
  test       run tests
  deploy     deploy the application
  help       show this message

Options:
  -v, --verbose                     enable verbose output
  -c, --config string               configuration file
      --dry-run                     show what would be done without executing
  -h, --help                        show this message and exit

# Basic command execution
$ ./class_option build
Building project...
Compiling source files...
Creating output directory...
Build completed!

# With verbose option
$ ./class_option build --verbose
Building project...
Config file: default.conf
Verbose mode: ON
Compiling source files...
Creating output directory...
Build completed!

# With dry-run option
$ ./class_option deploy --dry-run
Deploying application...
DRY RUN: Would upload files to server
DRY RUN: Would restart services

# With config file
$ ./class_option test --verbose --config custom.conf
Running tests...
Config file: custom.conf
Verbose mode: ON
Test suite passed!

# Multiple global options
$ ./class_option build --verbose --config build.conf --dry-run
Building project...
Config file: build.conf
Verbose mode: ON
DRY RUN: Would compile source files
DRY RUN: Would create output directory
```

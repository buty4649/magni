# Default command usage

This directory contains an example demonstrating how to use `default_command` feature in Magni.

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
$ ./default_command help

Commands:
  greet      greet someone
  hello      say hello message (default)
  help       show this message

Options:
  -h, --help                        show this message and exit

$ ./default_command
hello world

$ ./default_command greet
greetings

$ ./default_command hello --message "Ruby"
hello Ruby
```

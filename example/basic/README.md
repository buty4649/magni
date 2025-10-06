# Basic usage

This directory contains a basic example demonstrating how to use Magni to build CLI tools.

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
$ ./basic
Usage:
  MyAwesomeApp [command]

Commands:
  hello      say hello message
  info       show app information
  help       show this message

Options:
  -h, --help                        show this message and exit

$ ./basic hello
hello world
```

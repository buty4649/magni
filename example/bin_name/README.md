# Custom binary name usage

This directory contains an example demonstrating how to customize the binary name in Magni using `build_target` configuration.

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
$ ./mytool
Usage:
  MyTool [command]

Commands:
  greet      greet someone
  info       show tool information
  help       show this message

Options:
  -m, --message string              message to say
  -h, --help                        show this message and exit

$ ./mytool greet
Hello world from MyTool!

$ ./mytool info
Tool name: MyTool
Binary name: mytool
This demonstrates custom binary naming in Magni

$ ./mytool greet --message "Developer"
Hello Developer from MyTool!
```

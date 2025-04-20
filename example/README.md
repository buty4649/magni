# Example

This directory contains a sample CLI tool built with Magni.

## Prerequisites

You need build tools to build mruby. Please install a compiler in advance.
See: https://github.com/mruby/mruby/blob/master/doc/guides/compile.md

## Usage

First, build the sample code:

```sh
rake all
```

After building, you can run the command as follows.

### Example

```
$ ./build/host/bin/magni
Error: hello: wrong number of arguments (given 0, expected 1)

Usage:
  magni hello

Commands:
  hello      say hellotrue
  help       show this messagefalse
  version    show versionfalse

Options:
  -d, --desc string                 description
      --banner string               banner
  -h, --help                        show this message and exit

$ ./build/host/bin/magni --banner benner --desc desc world
benner
hello world
desc: desc
```

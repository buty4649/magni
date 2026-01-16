# Exclude Options Example

This directory contains an example demonstrating how to use Magni's `exclude_options` feature to create mutually exclusive command-line options.

## Prerequisites

You need build tools to build mruby. Please install a compiler in advance.
See: https://github.com/mruby/mruby/blob/master/doc/guides/compile.md

## Usage

Build the example:

```sh
rake
```

After building, you can run the command as follows:

### Example Usage

#### Basic Usage

```sh
$ ./exclude_options
Usage:
  FileManager [command]

Commands:
  manage     manage files with mutually exclusive options
  access     access files with read/write exclusion
  service    manage services with multiple exclusion groups
  help       show this message

Options:
  -h, --help                        show this message and exit
```

#### File Management with Mutually Exclusive Options

The `manage` command demonstrates how create, delete, and update operations are mutually exclusive:

```sh
# Valid usage - only one operation specified
$ ./exclude_options manage --create --file example.txt
Creating file: example.txt

$ ./exclude_options manage --delete --file example.txt
Deleting file: example.txt

$ ./exclude_options manage --update --file example.txt
Updating file: example.txt
```

```sh
# Invalid usage - multiple exclusive options will cause an error
$ ./exclude_options manage --create --delete --file example.txt
Error: Cannot specify these options together: --create, --delete

$ ./exclude_options manage --create --update --file example.txt
Error: Cannot specify these options together: --create, --update

$ ./exclude_options manage --create --delete --update --file example.txt
Error: Cannot specify these options together: --create, --delete, --update
```

#### Read/Write Mode Exclusion

The `access` command demonstrates read/write mode exclusion:

```sh
# Valid usage
$ ./exclude_options access --read --file data.txt
Accessing data.txt in reading mode

$ ./exclude_options access --write --verbose
Accessing default.txt in writing mode (verbose)
```

```sh
# Invalid usage - both read and write specified
$ ./exclude_options access --read --write
Error: Cannot specify these options together: --read, --write
```

#### Service Management with Multiple Exclusion Groups

The `service` command demonstrates multiple `exclude_options` calls, creating separate exclusion groups:

```sh
# Valid usage - one from each group
$ ./exclude_options service --start --foreground
Service starting in foreground

$ ./exclude_options service --stop --daemon
Service stopping as daemon

$ ./exclude_options service --restart
Service restarting with default settings
```

```sh
# Invalid usage - multiple actions specified (first exclusion group)
$ ./exclude_options service --start --stop
Error: Cannot specify these options together: --start, --stop

# Invalid usage - multiple modes specified (second exclusion group)
$ ./exclude_options service --foreground --daemon --start
Error: Cannot specify these options together: --foreground, --daemon

# Invalid usage - violations in both groups
$ ./exclude_options service --start --restart --foreground --daemon
Error: Cannot specify these options together: --start, --restart
```

## Key Features Demonstrated

1. **Multi-Option Exclusion**: The `manage` command shows how to define mutually exclusive options among three or more choices
2. **Simple Pair Exclusion**: The `access` command shows a simple two-option exclusion
3. **Multiple Exclusion Groups**: The `service` command demonstrates multiple `exclude_options` calls creating separate exclusion groups
4. **Error Handling**: Automatic error messages when conflicting options are used together
5. **Integration with Required Options**: Works alongside required options like `--file`
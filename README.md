EN | [JA](./README_ja.md)

---

# Magni

Magni is a framework for developing CLI tools with mruby. It includes the necessary files for building CLI tools with mruby, allowing you to build CLI tools with minimal configuration. It also provides an API similar to [Thor](https://github.com/rails/thor), a well-known CLI framework for CRuby, so if you have experience with that tool, you can develop efficiently.

## Features
- Lightweight CLI framework running on mruby
- [Thor](https://github.com/rails/thor)-like API
- Includes code necessary for building CLI tools

## Quick Start

### 1. Prepare Compiler
A C compiler is required to build mruby. See the [official mruby guide](https://github.com/mruby/mruby/blob/master/doc/guides/compile.md) for details.

### 2. Create Project Directory
Create a project directory with any directory name.
This directory name will be the executable file name after build by default.

```sh
mkdir mycli
cd mycli
```

### 3. Get mruby Source Code
Get the mruby source code using one of the following methods.

#### (A) Get with git clone
```sh
git clone https://github.com/mruby/mruby.git

# or git submodule (recommended)
git submodule add https://github.com/mruby/mruby.git
```

#### (B) Download from Official Site
Download and extract the archive from the [official mruby download page](https://mruby.org/downloads/).

### 4. Create build\_config.rb
Create `build_config.rb` in the project root and add the Magni gem.

```ruby
# build_config.rb
MRuby::Build.new do |conf|
  conf.toolchain
  conf.gembox 'default'
  conf.gem github: 'buty4649/magni', branch: 'main'
  conf.build_dir = File.join(__dir__, 'build')
end
```

### 5. Create Script
Create a script. The name is arbitrary, but here we use *cli.rb* as an example.
The script must define one class that inherits from the Magni class (here we use the Cli class).

```ruby
# cli.rb
class Cli < Magni
  package_name 'mycli'

  desc 'hello', 'say hello'
  def hello
    puts 'hello'
  end
end
```

### 6. Build and Binary Generation
Execute the following in the project root.
```sh
rake -f mruby/Rakefile
```

A binary named `./build/bin/mycli` will be generated (if the directory name is `mycli`).

```sh
$ ./build/bin/mycli
Usage:
  mycli [command]

Commands:
  hello      say hello
  help       show this message

Options:
  -h, --help                        show this message and exit
```

## Tips

### Change Binary File Name
You can change the output binary file name by specifying **bins** when loading magni as follows. In the following example, it is changed to *awesome-cli-tool*.

```ruby
MRuby::Build.new do |conf|
-- snip --
  conf.gem github: 'buty4649/magni', branch: 'main' do |g|
    g.bins = %w[awesome-cli-tool]
  end

-- snip --
end
```

### Split Scripts / Load Multiple Files

In mruby, `require` / `require_relative` cannot be used by default. However, all script files are loaded and built at build time. The files to be built are as follows:

* `./*.rb`
* `./app/**/*.rb`
* `./lib/**/*.rb`
* `./mrblib/**/*.rb`

> [!TIP]
> These paths are relative paths based on the directory where `build_config.rb` is located.

## LICENSE

See the [LICENSE](LICENSE) file for details.

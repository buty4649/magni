assert('Magni::OptionParser#initialize sets up parser correctly') do
  command = Struct.new(:name).new('test_command')
  specs = [
    Magni::Option.new('verbose', type: :boolean, aliases: ['v'], desc: 'verbose output'),
    Magni::Option.new('count', type: :numeric, default: 1, desc: 'count number')
  ]

  klass = Class.new do
    def self.options
      @options ||= {}
    end

    def self.help(command)
      puts "Help for #{command.name}"
    end
  end

  parser = Magni::OptionParser.new(command, specs, klass)
  assert_true parser.is_a?(Magni::OptionParser)
end

assert('Magni::OptionParser#parse_numeric_string handles integers') do
  command = Struct.new(:name).new('test')
  parser = Magni::OptionParser.new(command, [], Class.new)

  result = parser.parse_numeric_string('42')
  assert_equal 42, result
  assert_true result.is_a?(Integer)
end

assert('Magni::OptionParser#parse_numeric_string handles floats') do
  command = Struct.new(:name).new('test')
  parser = Magni::OptionParser.new(command, [], Class.new)

  result = parser.parse_numeric_string('3.14')
  assert_equal 3.14, result
  assert_true result.is_a?(Float)
end

assert('Magni::OptionParser#parse_numeric_string raises InvalidFormatError for invalid input') do
  command = Struct.new(:name).new('test')
  parser = Magni::OptionParser.new(command, [], Class.new)

  assert_raise(Magni::InvalidFormatError) do
    parser.parse_numeric_string('not_a_number')
  end
end

assert('Magni::OptionParser#parse_value handles numeric types') do
  command = Struct.new(:name).new('test')
  parser = Magni::OptionParser.new(command, [], Class.new)

  opt = Magni::Option.new('count', type: :numeric)
  result = parser.parse_value(opt, '123')
  assert_equal 123, result
end

assert('Magni::OptionParser#parse_value handles non-numeric types') do
  command = Struct.new(:name).new('test')
  parser = Magni::OptionParser.new(command, [], Class.new)

  opt = Magni::Option.new('name', type: :string)
  result = parser.parse_value(opt, 'test_value')
  assert_equal 'test_value', result
end

assert('Magni::Option#flags generates correct flags') do
  opt = Magni::Option.new('verbose', type: :boolean, aliases: ['v'])
  flags = opt.flags

  assert_true flags.is_a?(Array)
  assert_true flags.length >= 2
end

assert('Magni::OptionParser sets default values correctly') do
  klass = Class.new do
    def self.options
      @options ||= {}
    end

    def self.help(command); end
  end

  command = Struct.new(:name).new('test')
  specs = [
    Magni::Option.new('count', type: :numeric, default: 42),
    Magni::Option.new('name', type: :string, default: 'default_name')
  ]

  Magni::OptionParser.new(command, specs, klass)

  assert_equal 42, klass.options[:count]
  assert_equal 'default_name', klass.options[:name]
end

assert('Magni::OptionParser#help returns help text') do
  command = Struct.new(:name).new('test')
  specs = [
    Magni::Option.new('verbose', type: :boolean, aliases: ['v'], desc: 'verbose output')
  ]

  klass = Class.new do
    def self.options
      @options ||= {}
    end

    def self.help(command); end
  end

  parser = Magni::OptionParser.new(command, specs, klass)
  help_text = parser.help

  assert_true help_text.is_a?(String)
  assert_true help_text.include?('verbose')
end

assert('Magni::OptionParser handles parse with validation') do
  klass = Class.new do
    def self.options
      @options ||= {}
    end

    def self.help(command); end
  end

  command = Struct.new(:name).new('test')
  specs = [
    Magni::Option.new('name', type: :string)
  ]

  parser = Magni::OptionParser.new(command, specs, klass)

  result = parser.parse([])
  assert_true result.is_a?(Array)
end

assert('Magni::OptionParser handles optional argument with bracket suffix') do
  klass = Class.new do
    def self.options
      @options ||= {}
    end

    def self.help(command); end
  end

  command = Struct.new(:name).new('test')

  # Test with optional string argument provided
  assert('Test with optional string argument provided') do
    # Test string type optional argument
    specs = [
      Magni::Option.new('output', type: :string, aliases: ['o'], banner: '[FILE]')
    ]
    parser = Magni::OptionParser.new(command, specs, klass)

    klass.options.clear
    result = parser.parse(['--output', 'result.txt'])
    assert_true result.is_a?(Array)
    assert_equal 'result.txt', klass.options[:output]

    # Test with optional string argument omitted (should work without error)
    klass.options.clear
    result = parser.parse(['--output'])
    assert_true result.is_a?(Array)
    assert_equal '', klass.options[:output]
  end

  assert('Test with optional numeric argument provided') do
    # Test numeric type optional argument
    specs = [
      Magni::Option.new('port', type: :numeric, aliases: ['p'], banner: '[PORT]')
    ]

    parser = Magni::OptionParser.new(command, specs, klass)

    # Test with optional numeric argument provided
    klass.options.clear
    result = parser.parse(['--port', '8080'])
    assert_true result.is_a?(Array)
    assert_equal 8080, klass.options[:port]

    # Reset options for next test
    klass.options.clear

    # Test with optional numeric argument omitted (should work without error)
    result = parser.parse(['--port'])
    assert_true result.is_a?(Array)
    assert_equal 0, klass.options[:port]
  end
end

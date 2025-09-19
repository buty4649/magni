assert('Magni::Error is a subclass of StandardError') do
  err = Magni::Error.new
  assert_true err.is_a?(Magni::Error)
  assert_true err.is_a?(StandardError)
end

assert('Magni::RequiredOptionError initializes with correct message') do
  err = Magni::RequiredOptionError.new('username')
  assert_equal 'Error: username is required', err.message
  assert_true err.is_a?(Magni::Error)
end

assert('Magni::CommandNotFoundError initializes with correct message') do
  err = Magni::CommandNotFoundError.new('deploy')
  assert_equal 'Error: command deploy not found', err.message
  assert_true err.is_a?(Magni::Error)
end

assert('Magni::CommandArgumentError initializes with correct message') do
  command = Struct.new(:name).new('build')
  err = Magni::CommandArgumentError.new(command, 'missing target')
  assert_equal 'Error: build: missing target', err.message
  assert_true err.is_a?(Magni::Error)
end

assert('Magni::OptionTypeInvalidError initializes with correct message') do
  err = Magni::OptionTypeInvalidError.new('format')
  expected = "Error: format type must be one of: #{Magni::Option::VALID_TYPES.join(', ')}"
  assert_equal expected, err.message
  assert_true err.is_a?(Magni::Error)
end

assert('Magni::InvalidFormatError is a subclass of Magni::Error') do
  err = Magni::InvalidFormatError.new
  assert_true err.is_a?(Magni::InvalidFormatError)
  assert_true err.is_a?(Magni::Error)
end

assert('Magni::InvalidFormatError can accept custom message') do
  err = Magni::InvalidFormatError.new('custom message')
  assert_equal 'custom message', err.message
  assert_true err.is_a?(Magni::Error)
end

assert('Magni::InvalidOptionError initializes with correct message') do
  err = Magni::InvalidOptionError.new('color', %w[red green blue])
  assert_equal 'Error: color must be one of: red, green, blue', err.message
  assert_true err.is_a?(Magni::Error)
end

assert('Magni::InvalidOptionError handles empty enum array') do
  err = Magni::InvalidOptionError.new('empty', [])
  assert_equal 'Error: empty must be one of: ', err.message
  assert_true err.is_a?(Magni::Error)
end

assert('All error classes inherit from Magni::Error') do
  errors = [
    Magni::RequiredOptionError.new('test'),
    Magni::CommandNotFoundError.new('test'),
    Magni::CommandArgumentError.new(Struct.new(:name).new('test'), 'msg'),
    Magni::OptionTypeInvalidError.new('test'),
    Magni::InvalidFormatError.new,
    Magni::InvalidOptionError.new('test', ['a'])
  ]

  errors.each do |err|
    assert_true err.is_a?(Magni::Error), "#{err.class} should inherit from Magni::Error"
    assert_true err.is_a?(StandardError), "#{err.class} should inherit from StandardError"
  end
end

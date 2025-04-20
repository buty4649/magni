assert('Magni::RequiredOptionError raises with correct message') do
  assert_raise(Magni::RequiredOptionError, 'Error: foo is required') do
    raise Magni::RequiredOptionError, 'Error: foo is required'
  end
end

assert('Magni::CommandNotFoundError raises with correct message') do
  assert_raise(Magni::CommandNotFoundError, 'Error: command bar not found') do
    raise Magni::CommandNotFoundError, 'Error: command bar not found'
  end
end

assert('Magni::CommandArgumentError raises with correct message') do
  dummy = Struct.new(:name).new('baz')
  assert_raise(Magni::CommandArgumentError, 'Error: baz: bad arg') do
    raise Magni::CommandArgumentError.new(dummy, 'bad arg')
  end
end

assert('Magni::OptionTypeInvalidError raises with correct message') do
  assert_raise(Magni::OptionTypeInvalidError, 'Error: foo type must be one of: a, b') do
    raise Magni::OptionTypeInvalidError, 'Error: foo type must be one of: a, b'
  end
end

assert('Magni::InvalidFormatError is a subclass of Magni::Error') do
  err = Magni::InvalidFormatError.new
  assert_true err.is_a?(Magni::InvalidFormatError)
  assert_true err.is_a?(Magni::Error)
end

assert('Magni::InvalidOptionError raises with correct message') do
  assert_raise(Magni::InvalidOptionError, 'Error: foo must be one of: x, y') do
    raise Magni::InvalidOptionError.new('foo', %w[x y])
  end
end

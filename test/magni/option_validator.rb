assert('Magni::OptionValidator#required and #enums') do
  specs = [
    Magni::Option.new('foo', required: true),
    Magni::Option.new('bar', enum: %w[a b]),
    Magni::Option.new('baz')
  ]
  validator = Magni::OptionValidator.new(Object.new, specs, nil)
  reqs = validator.required
  ens = validator.enums
  assert_equal 1, reqs.size
  assert_equal :foo, reqs[0].name
  assert_equal 1, ens.size
  assert_equal :bar, ens[0].name
end

assert('Magni::OptionValidator#valid_required? success') do
  klass = Class.new do
    def options = { foo: 1 }
  end.new
  specs = [Magni::Option.new('foo', required: true)]
  validator = Magni::OptionValidator.new(klass, specs, nil)
  assert_true validator.valid_required?
end

assert('Magni::OptionValidator#valid_required? fail') do
  klass = Class.new do
    def options = {}
  end.new
  specs = [Magni::Option.new('foo', required: true)]
  validator = Magni::OptionValidator.new(klass, specs, nil)
  err = false
  begin
    validator.valid_required?
  rescue StandardError => e
    err = e.class.to_s.include?('RequiredOptionError')
  end
  assert_true err
end

assert('Magni::OptionValidator#valid_enums? success') do
  klass = Class.new do
    def options = { bar: 'a' }
  end.new
  specs = [Magni::Option.new('bar', enum: %w[a b])]
  validator = Magni::OptionValidator.new(klass, specs, nil)
  assert_true validator.valid_enums?
end

assert('Magni::OptionValidator#valid_enums? fail') do
  klass = Class.new do
    def options = { bar: 'c' }
  end.new
  specs = [Magni::Option.new('bar', enum: %w[a b])]
  validator = Magni::OptionValidator.new(klass, specs, nil)
  err = false
  begin
    validator.valid_enums?
  rescue StandardError => e
    err = e.class.to_s.include?('InvalidOptionError')
  end
  assert_true err
end

assert('Magni::OptionValidator#valid_enums? repeatable') do
  klass = Class.new do
    def options = { bar: %w[a b] }
  end.new
  specs = [Magni::Option.new('bar', enum: %w[a b], repeatable: true)]
  validator = Magni::OptionValidator.new(klass, specs, nil)
  assert_true validator.valid_enums?

  klass2 = Class.new do
    def options = { bar: %w[a c] }
  end.new
  validator2 = Magni::OptionValidator.new(klass2, specs, nil)
  err = false
  begin
    validator2.valid_enums?
  rescue StandardError => e
    err = e.class.to_s.include?('InvalidOptionError')
  end
  assert_true err
end

assert('Magni::OptionValidator#valid_exclude_options? success') do
  klass = Class.new do
    def options = { foo: 1 }
  end.new
  specs = [
    Magni::Option.new('foo'),
    Magni::Option.new('bar')
  ]
  exclude_options = [%i[foo bar]]
  validator = Magni::OptionValidator.new(klass, specs, exclude_options)
  # Should not raise an error when only one option is specified
  result = validator.valid_exclude_options?
  assert_true result
end

assert('Magni::OptionValidator#valid_exclude_options? fail') do
  klass = Class.new do
    def options = { foo: 1, bar: 2 }
  end.new
  specs = [
    Magni::Option.new('foo'),
    Magni::Option.new('bar')
  ]
  exclude_options = [%i[foo bar]]
  validator = Magni::OptionValidator.new(klass, specs, exclude_options)
  err = false
  begin
    validator.valid_exclude_options?
  rescue StandardError => e
    err = e.class.to_s.include?('ExcludeOptionsError')
  end
  assert_true err
end

assert('Magni::OptionValidator#valid_exclude_options? with 3 options fail') do
  klass = Class.new do
    def options = { create: true, delete: true, update: false }
  end.new
  specs = [
    Magni::Option.new('create'),
    Magni::Option.new('delete'),
    Magni::Option.new('update')
  ]
  exclude_options = [%i[create delete update]]
  validator = Magni::OptionValidator.new(klass, specs, exclude_options)
  err = false
  begin
    validator.valid_exclude_options?
  rescue StandardError => e
    err = e.class.to_s.include?('ExcludeOptionsError')
  end
  assert_true err
end

assert('Magni::OptionValidator#valid_exclude_options? with multiple groups') do
  klass = Class.new do
    def options = { foo: 1, bar: 2 }
  end.new
  specs = [
    Magni::Option.new('foo'),
    Magni::Option.new('bar'),
    Magni::Option.new('baz'),
    Magni::Option.new('qux')
  ]
  # Multiple exclude groups: [foo, bar] and [baz, qux]
  exclude_options = [%i[foo bar], %i[baz qux]]
  validator = Magni::OptionValidator.new(klass, specs, exclude_options)
  err = false
  begin
    validator.valid_exclude_options?
  rescue StandardError => e
    err = e.class.to_s.include?('ExcludeOptionsError')
  end
  assert_true err
end

assert('Magni::OptionValidator#valid_exclude_options? with multiple groups success') do
  klass = Class.new do
    def options = { foo: 1, qux: 2 }
  end.new
  specs = [
    Magni::Option.new('foo'),
    Magni::Option.new('bar'),
    Magni::Option.new('baz'),
    Magni::Option.new('qux')
  ]
  # Multiple exclude groups: [foo, bar] and [baz, qux]
  # Only one from each group is specified, so should be valid
  exclude_options = [%i[foo bar], %i[baz qux]]
  validator = Magni::OptionValidator.new(klass, specs, exclude_options)
  result = validator.valid_exclude_options?
  assert_true result
end

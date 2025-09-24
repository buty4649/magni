assert('Magni::OptionValidator#required and #enums') do
  specs = [
    Magni::Option.new('foo', required: true),
    Magni::Option.new('bar', enum: %w[a b]),
    Magni::Option.new('baz')
  ]
  validator = Magni::OptionValidator.new(Object.new, specs)
  reqs = validator.required
  ens = validator.enums
  assert_equal 1, reqs.size
  assert_equal :foo, reqs[0].name
  assert_equal 1, ens.size
  assert_equal :bar, ens[0].name
end

assert('Magni::OptionValidator#validate_required? success') do
  klass = Class.new do
    def options = { :foo => 1 }
  end.new
  specs = [Magni::Option.new('foo', required: true)]
  validator = Magni::OptionValidator.new(klass, specs)
  assert_true validator.validate_required?
end

assert('Magni::OptionValidator#validate_required? fail') do
  klass = Class.new do
    def options = {}
  end.new
  specs = [Magni::Option.new('foo', required: true)]
  validator = Magni::OptionValidator.new(klass, specs)
  err = false
  begin
    validator.validate_required?
  rescue StandardError => e
    err = e.class.to_s.include?('RequiredOptionError')
  end
  assert_true err
end

assert('Magni::OptionValidator#validate_enum success') do
  klass = Class.new do
    def options = { :bar => 'a' }
  end.new
  specs = [Magni::Option.new('bar', enum: %w[a b])]
  validator = Magni::OptionValidator.new(klass, specs)
  assert_true validator.validate_enum
end

assert('Magni::OptionValidator#validate_enum fail') do
  klass = Class.new do
    def options = { :bar => 'c' }
  end.new
  specs = [Magni::Option.new('bar', enum: %w[a b])]
  validator = Magni::OptionValidator.new(klass, specs)
  err = false
  begin
    validator.validate_enum
  rescue StandardError => e
    err = e.class.to_s.include?('InvalidOptionError')
  end
  assert_true err
end

assert('Magni::OptionValidator#validate_enum repeatable') do
  klass = Class.new do
    def options = { :bar => %w[a b] }
  end.new
  specs = [Magni::Option.new('bar', enum: %w[a b], repeatable: true)]
  validator = Magni::OptionValidator.new(klass, specs)
  assert_true validator.validate_enum

  klass2 = Class.new do
    def options = { :bar => %w[a c] }
  end.new
  validator2 = Magni::OptionValidator.new(klass2, specs)
  err = false
  begin
    validator2.validate_enum
  rescue StandardError => e
    err = e.class.to_s.include?('InvalidOptionError')
  end
  assert_true err
end

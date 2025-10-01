assert('Magni::Base::ClassOptions.class_option adds a class option') do
  klass = Class.new do
    extend Magni::Base::ClassOptions
  end
  klass.class_option('bar', type: :numeric)
  assert_true(klass.class_options.any? { |opt| opt.name == :bar && opt.type == :numeric })
end

assert('Magni::Base::ClassOptions.default_command sets and gets default command') do
  klass = Class.new do
    extend Magni::Base::ClassOptions

    def self.default_command_val = @default_command
  end
  klass.default_command(:foo)
  assert_equal :foo, klass.default_command_val
  assert_true klass.default_command?(:foo)
  assert_false klass.default_command?(:bar)
end

assert('Magni::Base::ClassOptions.package_name sets and gets package name') do
  klass = Class.new do
    extend Magni::Base::ClassOptions
  end
  klass.package_name('magni-test')
  assert_equal 'magni-test', klass.package_name
end

assert('Magni::Base::ClassOptions.app_name is alias for package_name') do
  klass = Class.new do
    extend Magni::Base::ClassOptions
  end
  klass.app_name('test-app')
  assert_equal 'test-app', klass.package_name
  assert_equal 'test-app', klass.app_name
end

assert('Magni::Base::ClassOptions.no_commands allows method definition without creating commands') do
  klass = Class.new do
    extend Magni::Base::ClassOptions

    def self.no_commands_val = @no_commands
  end

  klass.no_commands do
    # Simulate defining methods within no_commands block
  end

  # After the block, @no_commands should be false
  assert_false klass.no_commands_val
end

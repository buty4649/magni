assert('Magni::Base::ClassMethods.desc sets usage and description') do
  klass = Class.new do
    extend Magni::Base::ClassMethods
    def self.usage_val = @usage
    def self.description_val = @description
  end
  klass.desc('USAGE', 'DESCRIPTION')
  assert_equal 'USAGE', klass.usage_val
  assert_equal 'DESCRIPTION', klass.description_val
end

assert('Magni::Base::ClassMethods.option adds an option') do
  klass = Class.new do
    extend Magni::Base::ClassMethods
  end
  klass.option('foo', type: :boolean)
  assert_true(klass.options.any? { |opt| opt.name == 'foo' && opt.type == :boolean })
end

assert('Magni::Base::ClassMethods.class_option adds a class option') do
  klass = Class.new do
    extend Magni::Base::ClassMethods
  end
  klass.class_option('bar', type: :numeric)
  assert_true(klass.class_options.any? { |opt| opt.name == 'bar' && opt.type == :numeric })
end

assert('Magni::Base::ClassMethods.default_command sets and gets default command') do
  klass = Class.new do
    extend Magni::Base::ClassMethods
    def self.default_command_val = @default_command
  end
  klass.default_command(:foo)
  assert_equal :foo, klass.default_command_val
  assert_true klass.default_command?(:foo)
  assert_false klass.default_command?(:bar)
end

assert('Magni::Base::ClassMethods.package_name sets and gets package name') do
  klass = Class.new do
    extend Magni::Base::ClassMethods
  end
  klass.package_name('magni-test')
  assert_equal 'magni-test', klass.package_name
end

assert('Magni::Base::ClassMethods.commands returns help command by default') do
  klass = Class.new do
    extend Magni::Base::ClassMethods
  end
  cmds = klass.commands
  assert_true cmds.key?(:help)
  assert_true cmds[:help].respond_to?(:description)
end

assert('Magni::Base::ClassMethods.help_text includes usage and commands') do
  klass = Class.new do
    extend Magni::Base::ClassMethods
    def self.using_default? = true
    def self.current_command = Struct.new(:name).new(:help)
    def self.package_name = 'magni-test'

    def self.commands
      { foo: Magni::Command.new(:foo, 'foo usage', 'foo desc', []), help: Magni::Command.new(:help, 'help', 'show this message', []) }
    end

    def self.default_command = :foo
    def self.default_command?(name) = name == :foo
  end
  text = klass.help_text
  assert_true text.include?('Usage:')
  assert_true text.include?('Commands:')
  assert_true text.include?('foo desc')
end

assert('Magni::Base::Dispatcher#current_command= and #current_command') do
  klass = Class.new do
    include Magni::Base::Dispatcher
  end
  obj = klass.new
  obj.current_command = :foo
  assert_equal :foo, obj.current_command
end

assert('Magni::Base::Dispatcher#using_default? returns false by default and true after fallback_default_command') do
  klass = Class.new do
    include Magni::Base::Dispatcher

    def self.default_command = :bar
    def self.commands = { bar: :barcmd }
  end
  obj = klass.new
  assert_false obj.using_default?
  obj.fallback_default_command(klass)
  assert_true obj.using_default?
end

assert('Magni::Base::Dispatcher#select_command') do
  assert('returns command and argv') do
    klass = Class.new do
      include Magni::Base::Dispatcher

      def self.commands = { foo: :foocmd }
    end
    obj = klass.new
    cmd, argv = obj.select_command(%w[foo arg1], klass)
    assert_equal :foocmd, cmd
    assert_equal ['arg1'], argv
  end

  assert('returns nil if no command') do
    klass = Class.new do
      include Magni::Base::Dispatcher

      def self.commands = {}
    end
    obj = klass.new
    cmd, argv = obj.select_command(['bar'], klass)
    assert_nil cmd
    assert_equal ['bar'], argv
  end

  assert('returns nil if argv starts with dash') do
    klass = Class.new do
      include Magni::Base::Dispatcher

      def self.commands = { foo: :foocmd }
    end
    obj = klass.new
    cmd, argv = obj.select_command(['-h', 'foo'], klass)
    assert_nil cmd
    assert_equal ['-h', 'foo'], argv
  end
end

assert('Magni::Base::Dispatcher#fallback_default_command') do
  assert('returns command if exists') do
    klass = Class.new do
      include Magni::Base::Dispatcher

      def self.default_command = :foo
      def self.commands = { foo: :foocmd }
    end
    obj = klass.new
    cmd = obj.fallback_default_command(klass)
    assert_equal :foocmd, cmd
  end

  assert('returns nil if no default_command') do
    klass = Class.new do
      include Magni::Base::Dispatcher

      def self.default_command = nil
      def self.commands = {}
    end
    obj = klass.new
    cmd = obj.fallback_default_command(klass)
    assert_nil cmd
  end
end

assert('Magni::Base::Dispatcher#invoke_command calls klass.invoke_command') do
  klass = Class.new do
    include Magni::Base::Dispatcher

    def self.invoke_command(command, *argv)
      [command, argv]
    end
  end
  obj = klass.new
  result = obj.invoke_command(:foo, [1, 2], klass)
  assert_equal [:foo, [1, 2]], result
end

assert('Magni::Base::ClassMethods.show_help_on_failure? returns true') do
  klass = Class.new do
    include Magni::Base::Dispatcher
  end
  obj = klass.new
  assert_true obj.show_help_on_failure?
end

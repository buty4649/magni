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
  obj.__send__(:fallback_default_command, klass)
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

  assert('supports command abbreviation') do
    klass = Class.new do
      include Magni::Base::Dispatcher

      def self.commands = { execute: :executecmd, start: :startcmd, help: :helpcmd }
    end
    obj = klass.new

    # Exact match takes precedence
    cmd, argv = obj.select_command(%w[execute arg1], klass)
    assert_equal :executecmd, cmd
    assert_equal ['arg1'], argv

    # Single character abbreviation
    cmd, argv = obj.select_command(%w[e arg1], klass)
    assert_equal :executecmd, cmd
    assert_equal ['arg1'], argv

    # Partial abbreviation
    cmd, argv = obj.select_command(%w[exec arg1], klass)
    assert_equal :executecmd, cmd
    assert_equal ['arg1'], argv

    # Different single character
    cmd, argv = obj.select_command(%w[s arg1], klass)
    assert_equal :startcmd, cmd
    assert_equal ['arg1'], argv

    # Another single character
    cmd, argv = obj.select_command(%w[h arg1], klass)
    assert_equal :helpcmd, cmd
    assert_equal ['arg1'], argv
  end

  assert('raises error for ambiguous abbreviation') do
    klass = Class.new do
      include Magni::Base::Dispatcher

      def self.commands = { execute: :executecmd, exit: :exitcmd }
    end
    obj = klass.new

    assert_raise(Magni::AmbiguousCommandError) do
      obj.select_command(['ex'], klass)
    end
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
    cmd = obj.__send__(:fallback_default_command, klass)
    assert_equal :foocmd, cmd
  end

  assert('returns nil if no default_command') do
    klass = Class.new do
      include Magni::Base::Dispatcher

      def self.default_command = nil
      def self.commands = {}
    end
    obj = klass.new
    cmd = obj.__send__(:fallback_default_command, klass)
    assert_nil cmd
  end
end

assert('Magni::Base::Dispatcher#find_command_by_abbreviation') do
  assert('returns command for exact abbreviation match') do
    klass = Class.new do
      include Magni::Base::Dispatcher
    end
    obj = klass.new
    commands = { execute: :executecmd, start: :startcmd, help: :helpcmd }

    # Single character match
    cmd = obj.__send__(:find_command_by_abbreviation, 'e', commands)
    assert_equal :executecmd, cmd

    # Partial match
    cmd = obj.__send__(:find_command_by_abbreviation, 'exec', commands)
    assert_equal :executecmd, cmd

    # Different single character
    cmd = obj.__send__(:find_command_by_abbreviation, 's', commands)
    assert_equal :startcmd, cmd
  end

  assert('returns nil for no match') do
    klass = Class.new do
      include Magni::Base::Dispatcher
    end
    obj = klass.new
    commands = { execute: :executecmd, start: :startcmd }

    cmd = obj.__send__(:find_command_by_abbreviation, 'z', commands)
    assert_nil cmd
  end

  assert('raises error for ambiguous abbreviation') do
    klass = Class.new do
      include Magni::Base::Dispatcher
    end
    obj = klass.new
    commands = { execute: :executecmd, exit: :exitcmd }

    assert_raise(Magni::AmbiguousCommandError) do
      obj.__send__(:find_command_by_abbreviation, 'ex', commands)
    end
  end

  assert('error message contains all matching commands') do
    klass = Class.new do
      include Magni::Base::Dispatcher
    end
    obj = klass.new
    commands = { execute: :executecmd, exit: :exitcmd, export: :exportcmd }

    begin
      obj.__send__(:find_command_by_abbreviation, 'ex', commands)
      assert_true false, 'Expected Magni::AmbiguousCommandError to be raised'
    rescue Magni::AmbiguousCommandError => e
      assert_true e.message.include?('execute')
      assert_true e.message.include?('exit')
      assert_true e.message.include?('export')
    end
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

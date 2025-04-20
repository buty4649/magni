assert('Magni::Base::Methods#invoke_command calls the method') do
  klass = Class.new do
    include Magni::Base::Methods
    def foo(x, y) # rubocop:disable Naming/MethodParameterName
      x + y
    end
  end
  obj = klass.new
  command = Struct.new(:name).new(:foo)
  result = obj.invoke_command(command, 1, 2)
  assert_equal 3, result
end

assert('Magni::Base::Methods#invoke_command raises CommandArgumentError on wrong args') do
  klass = Class.new do
    include Magni::Base::Methods
    def foo(_); end
  end
  obj = klass.new
  command = Struct.new(:name).new(:foo)
  err = nil
  begin
    obj.invoke_command(command)
  rescue StandardError => e
    err = e
  end
  assert_true err.is_a?(Magni::CommandArgumentError)
end

assert('Magni::Base::Methods#help') do
  assert('outputs help and exits (no commands)') do
    klass = Class.new do
      include Magni::Base::Methods
      def self.commands = { help: Struct.new(:name, :description).new(:help, 'show this message') }
      def self.help_text = 'helptext'
      def self.current_command = Struct.new(:help).new('optionhelp')
    end

    stub = lambda do |msg|
      assert_equal 'No commands found', msg
    end

    $stderr.stub(:puts, stub) do
      assert_raise(SystemExit) do
        klass.new.help
      end
    end
  end

  assert('outputs helptext and command list when commands exist') do
    klass = Class.new do
      include Magni::Base::Methods
      def self.commands
        {
          foo: Struct.new(:name, :description).new(:foo, 'desc foo'),
          help: Struct.new(:name, :description).new(:help, 'show this message')
        }
      end

      def self.help_text = 'helptext'
      def self.current_command = Struct.new(:help).new('optionhelp')
    end
    stub_puts = lambda do |msg|
      expected_output = <<~OUTPUT.chomp
        helptext
        Options:
        optionhelp
      OUTPUT
      assert_equal expected_output, msg
    end
    $stderr.stub(:puts, stub_puts) do
      assert_raise(SystemExit) do
        klass.new.help
      end
    end
  end
end

assert('Magni::Base::Methods#show_help_on_failure? returns true') do
  klass = Class.new do
    include Magni::Base::Methods
  end
  obj = klass.new
  assert_true obj.show_help_on_failure?
end

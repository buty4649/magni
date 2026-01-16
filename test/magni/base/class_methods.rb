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
      {
        foo: Magni::Command.new({ name: :foo, usage: 'foo usage', description: 'foo desc', order: 0, options: [] }),
        help: Magni::Command.new({ name: :help, usage: 'help', description: 'show this message', order: 99,
                                   options: [] })
      }
    end

    def self.default_command = :foo
    def self.default_command?(name) = name == :foo
  end
  text = klass.help_text
  assert_true text.include?('Usage:')
  assert_true text.include?('Commands:')
  assert_true text.include?('foo desc')
end

assert('Magni::Base::ClassMethods.ordered_commands returns commands ordered by order then name') do
  klass = Class.new do
    extend Magni::Base::ClassMethods

    def self.commands
      {
        zebra: Magni::Command.new({ name: :zebra, usage: 'zebra usage', description: 'zebra desc', order: 1,
                                    options: [] }),
        alpha: Magni::Command.new({ name: :alpha, usage: 'alpha usage', description: 'alpha desc', order: 1,
                                    options: [] }),
        beta: Magni::Command.new({ name: :beta, usage: 'beta usage', description: 'beta desc', order: 0, options: [] }),
        gamma: Magni::Command.new({ name: :gamma, usage: 'gamma usage', description: 'gamma desc', order: 2,
                                    options: [] })
      }
    end
  end

  ordered = klass.ordered_commands
  names = ordered.map(&:name)

  # Should be ordered by order (0, 1, 2), then by name within same order
  assert_equal %i[beta alpha zebra gamma], names
end

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
      { foo: Magni::Command.new(:foo, 'foo usage', 'foo desc', 0, []), help: Magni::Command.new(:help, 'help', 'show this message', 99, []) }
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
        zebra: Magni::Command.new(:zebra, 'zebra usage', 'zebra desc', 1, []),
        alpha: Magni::Command.new(:alpha, 'alpha usage', 'alpha desc', 1, []),
        beta: Magni::Command.new(:beta, 'beta usage', 'beta desc', 0, []),
        gamma: Magni::Command.new(:gamma, 'gamma usage', 'gamma desc', 2, [])
      }
    end
  end

  ordered = klass.ordered_commands
  names = ordered.map(&:name)

  # Should be ordered by order (0, 1, 2), then by name within same order
  assert_equal %i[beta alpha zebra gamma], names
end

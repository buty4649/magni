class Magni
  module Base
    module ClassMethods
      include Base::Dispatcher
      include Base::MethodOptions
      include Base::ClassOptions

      def inherited(subclass)
        super
        @@subclass = subclass # rubocop:disable Style/ClassVars
      end

      def subclass
        @@subclass
      end

      def current
        @@current ||= subclass.new # rubocop:disable Style/ClassVars
      end

      def current=(klass)
        @@current = klass # rubocop:disable Style/ClassVars
      end

      def commands
        @commands ||= { help: help_command }
      end

      def help_text
        text = formatted_usage

        if using_default? || current_command.name == :help
          text << "\nCommands:\n"
          ordered_commands.each do |command|
            name = command.name
            description = command.description
            is_default = default_command != :help && default_command?(name)
            suffix = is_default ? ' (default)' : ''

            text += format("  %-10<name>s %<description>s%<suffix>s\n", name:, description:, suffix:)
          end
        end

        text
      end

      def ordered_commands
        ordered = {}
        commands.each do |name, command|
          ordered[command.order] ||= []
          ordered[command.order] << name
        end

        ordered.keys.sort.map do |key|
          ordered[key].sort.map do |name|
            commands[name]
          end
        end.flatten
      end

      def formatted_usage
        return '' unless package_name

        command = (current_command.usage unless using_default? || current_command.name == :help)
        usage_text = usage(package_name, command).split("\n").map { |line| "  #{line}" }.join("\n")
        <<~USAGE
          Usage:
          #{usage_text}
        USAGE
      end

      def usage(name, command)
        [name, command || '[command]'].join(' ')
      end

      def start(argv = ARGV)
        dispatch(argv.dup)
      end

      protected

      def method_added(meth)
        super

        return if @no_commands || meth == :initialize || is_a?(Magni)

        commands[meth] = Command.new(meth, @usage, @description, @order, options)

        @usage = nil
        @description = nil
        @order = 0
        @options = []
      end

      def help_command
        order = 99
        Command.new(:help, 'help', 'show this message', order, [])
      end
    end
  end
end

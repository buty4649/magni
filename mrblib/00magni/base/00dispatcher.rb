class Magni
  module Base
    module Dispatcher
      attr_reader :current_command

      def current_command=(cmd)
        @current_command = cmd
      end

      def using_default?
        @using_default ||= false
      end

      def dispatch(argv, klass = Magni.current)
        command, argv = select_command(argv, klass.class)
        command ||= fallback_default_command(klass.class)

        # No commands found, show help and exit
        klass.help unless command

        self.current_command = command

        argv = command.parser.parse(argv)

        invoke_command(command, argv, klass)
      rescue Magni::Error, ::OptionParser::ParseError => e
        $stderr.puts "Error: #{e.message}"

        if show_help_on_failure?
          $stderr.puts
          klass.help(command, exit_after_help: false)
        end

        exit 1
      end

      def show_help_on_failure?
        true
      end

      def invoke_command(command, argv, klass = Magni.current)
        klass.invoke_command(command, *argv)
      end

      def select_command(argv, klass)
        return [nil, argv] if argv.first&.start_with?('-')

        command = klass.commands[argv.first&.to_sym]
        return [nil, argv] unless command

        [command, argv[1..]]
      end

      def fallback_default_command(klass)
        return unless klass.default_command

        command = klass.commands[klass.default_command]
        return unless command

        @using_default = true
        command
      end
    end
  end
end

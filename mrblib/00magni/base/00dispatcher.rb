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

        input = argv.first&.to_s
        return [nil, argv] unless input

        # Try exact match first
        command = klass.commands[input.to_sym]
        return [command, argv[1..]] if command

        # Try abbreviation match
        command = find_command_by_abbreviation(input, klass.commands)
        return [command, argv[1..]] if command

        [nil, argv]
      end

      private

      def find_command_by_abbreviation(input, commands)
        # Find all commands that start with the input
        matches = commands.keys.select { |cmd| cmd.to_s.start_with?(input) }

        case matches.size
        when 0
          nil
        when 1
          commands[matches.first]
        else
          # Multiple matches found - this is ambiguous
          raise Magni::AmbiguousCommandError.new(input, matches)
        end
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

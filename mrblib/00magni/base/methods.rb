class Magni
  module Base
    module Methods
      def invoke_command(command, *argv)
        __send__(command.name, *argv)
      rescue ArgumentError => e
        raise CommandArgumentError.new(command.name, e.message)
      end

      def help(*, exit_after_help: true)
        msg = if self.class.commands.size == 1 && self.class.commands.keys.first == :help
                'No commands found'
              else
                m = self.class.help_text
                m << "\nOptions:\n"
                m << self.class.current_command.help
              end
        $stderr.puts msg

        exit if exit_after_help
      end
    end
  end
end

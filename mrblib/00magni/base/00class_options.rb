class Magni
  module Base
    module ClassOptions
      def class_options
        @class_options ||= []
      end

      def class_option(name, options = {})
        class_options << Option.build(name, options)
      end

      def default_command(meth = nil)
        if meth
          @default_command = meth.is_a?(Symbol) ? meth : meth.to_sym
        else
          @default_command ||= :help
        end
      end

      def default_command?(meth)
        @default_command == meth
      end

      def package_name(name = nil)
        if name
          @package_name = name
        else
          @package_name
        end
      end
      alias app_name package_name

      def no_commands
        return unless block_given?

        @no_commands = true
        yield
        @no_commands = false
      end
    end
  end
end

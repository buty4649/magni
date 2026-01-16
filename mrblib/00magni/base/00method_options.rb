class Magni
  module Base
    module MethodOptions
      def desc(usage, description)
        @usage = usage
        @description = description
      end

      def order(order)
        @order = order
      end

      attr_reader :options

      def option(name, options = {})
        @options ||= []
        @options << Option.build(name, options)
      end

      def exclude_options(*opts)
        opts = opts.flatten
        raise 'exclude_options requires at least 2 options' if opts.size < 2

        @exclude_options ||= []
        @exclude_options << opts
      end
    end
  end
end

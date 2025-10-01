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
    end
  end
end

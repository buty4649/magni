class Magni
  class Command
    attr_reader :name, :usage, :description, :order, :options

    def initialize(name, usage, description, order, options)
      @name = name
      @usage = usage
      @description = description
      @order = order || 0
      @options = options || []
    end

    def parser(klass = Magni.current)
      @parser ||= OptionParser.new(self, options + klass.class.class_options, klass)
    end

    def help
      parser.help
    end
  end
end

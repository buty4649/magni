class Magni
  class Command
    attr_reader :name, :usage, :description, :options

    def initialize(name, usage, description, options)
      @name = name
      @usage = usage
      @description = description
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

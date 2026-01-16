class Magni
  class Command
    attr_reader :name, :usage, :description, :order, :options, :exclude_options

    def initialize(cmd)
      @name = cmd[:name]
      @usage = cmd[:usage]
      @description = cmd[:description]
      @order = cmd[:order] || 0
      @options = cmd[:options] || []
      @exclude_options = cmd[:exclude_options]
    end

    def parser(klass = Magni.current)
      @parser ||= OptionParser.new(self, options + klass.class.class_options, klass)
    end

    def help
      parser.help
    end
  end
end

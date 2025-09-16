class Magni
  class OptionParser
    def initialize(command, specs, klass)
      @parser = ::OptionParser.new
      @validator = OptionValidator.new(klass, specs)

      build(command, specs, klass)
    end

    def build(command, specs, klass)
      specs.each do |opt|
        o = flags(opt)
        o << opt.desc if opt.desc

        @parser.on(*o) do |value|
          v = parse_value(opt, value)

          if opt.repeatable
            klass.options[opt.name] ||= []
            klass.options[opt.name] << v
          else
            klass.options[opt.name] = v
          end
        end
      end

      @parser.on('-h', '--help', 'show this message and exit') do
        klass.help(command)
      end
    end

    def help
      @parser.help
    end

    def parse(argv)
      argv = @parser.parse(argv)

      @validator.validate

      argv
    end

    def flags(opt)
      flag = opt.aliases.map { |a| Option.flag(a.to_s) }
      flag << Option.flag(opt.name.to_s, opt.type, opt.banner)

      flag
    end

    def parse_value(opt, value)
      if opt.type == :numeric
        parse_numeric_string(value)
      else
        value
      end
    end

    def parse_numeric_string(value)
      if value.include?('.')
        Float(value)
      else
        Integer(value)
      end
    rescue ArgumentError => e
      raise InvalidFormatError, "Error: #{e.message}"
    end
  end
end

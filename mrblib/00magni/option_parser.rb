class Magni
  class OptionParser
    def initialize(command, specs, klass)
      @parser = ::OptionParser.new
      @specs = specs
      @validator = OptionValidator.new(klass, @specs)

      @specs.each do |spec|
        build(spec, klass)
      end

      @parser.on('-h', '--help', 'show this message and exit') do
        klass.help(command)
      end
    end

    def build(spec, klass)
      o = spec.flags
      o << spec.desc if spec.desc

      @parser.on(*o) do |value|
        v = parse_value(spec, value)

        if spec.repeatable
          klass.options[spec.name] ||= []
          klass.options[spec.name] << v
        else
          klass.options[spec.name] = v
        end
      end

      klass.options[spec.name] = spec.default if spec.default
    end

    def help
      @parser.help
    end

    def parse(argv)
      argv = @parser.parse(argv)

      @validator.validate

      argv
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

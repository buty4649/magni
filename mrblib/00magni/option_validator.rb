class Magni
  class OptionValidator
    def initialize(klass, specs)
      @klass = klass
      @specs = specs
    end

    def validate
      validate_required?
      validate_enum
    end

    def validate_required?
      required.each do |opt|
        raise RequiredOptionError, Option.flag(opt.name.to_s) unless @klass.options[opt.name]
      end

      true
    end

    def required
      @specs.select(&:required)
    end

    def validate_enum
      invalid = enums.find do |opt|
        if opt.repeatable
          @klass.options[opt.name]&.any? { |v| !opt.enum.include?(v) }
        else
          !opt.enum.include?(@klass.options[opt.name])
        end
      end

      return true unless invalid

      raise InvalidOptionError.new(Option.flag(invalid.name.to_s), invalid.enum)
    end

    def enums
      @specs.select { |s| s.enum.any? }
    end
  end
end

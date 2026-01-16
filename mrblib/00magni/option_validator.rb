class Magni
  class OptionValidator
    # Initialize the option validator
    # @param klass [Magni] Command class instance that holds options hash for validation
    # @param specs [Array<Magni::Option>] Array of option specifications with validation rules
    # @param exclude_options [Array<Array<Symbol>>]
    def initialize(klass, specs, exclude_options)
      @klass = klass
      @specs = specs
      @exclude_options = exclude_options
    end

    def valid?
      valid_required?
      valid_enums?
      valid_exclude_options?
    end

    def valid_required?
      required.each do |opt|
        raise RequiredOptionError, opt.flag(suffix: false) unless @klass.options[opt.name]
      end

      true
    end

    def required
      @specs.select(&:required)
    end

    def valid_enums?
      invalid = enums.find do |opt|
        if opt.repeatable
          @klass.options[opt.name]&.any? { |v| !opt.enum.include?(v) }
        else
          !opt.enum.include?(@klass.options[opt.name])
        end
      end

      return true unless invalid

      raise InvalidOptionError.new(invalid.flag(suffix: false), invalid.enum)
    end

    def enums
      @specs.select { |s| s.enum.any? }
    end

    def valid_exclude_options?
      @exclude_options&.each do |excludes|
        opts = excludes.select { |e| @klass.options.key?(e) }
        if opts.size > 1
          flags = opts.map { |e| @specs.find { |s| s.name == e }.flag(suffix: false) }
          raise ExcludeOptionsError, flags
        end
      end

      true
    end
  end
end

class Magni
  class Option
    VALID_ATTRS = %i[name aliases banner default desc display_name required type enum repeatable].freeze
    attr_reader(*VALID_ATTRS)

    VALID_TYPES = %i[string numeric boolean flag].freeze

    def initialize(name, options = {})
      @name = name.to_sym
      @type = options[:type] || :string
      @aliases = [options[:aliases]].flatten.compact.map(&:to_s)
      @default = options[:default]
      @desc = options[:desc]
      @display_name = options[:display_name]
      @required = options[:required]
      @banner = options[:banner] || (@type.to_s unless %i[boolean flag].include?(type))
      @enum = [options[:enum]].flatten.compact
      @repeatable = options[:repeatable]

      validate
    end

    def validate
      raise OptionTypeInvalidError, name unless VALID_TYPES.include?(type)
      raise OptionAttributeInvalidError.new(name, 'banner') if %i[boolean flag].include?(type) && banner
    end

    def self.build(name, options = {})
      options.keys.each do |key| # rubocop: disable Performance/HashEachMethods
        raise OptionAttributeInvalidError.new(name, key) unless VALID_ATTRS.include?(key)
      end

      new(name, options)
    end

    def flag(suffix: true)
      to_flag(display_name || name.to_s, suffix)
    end

    def flags(suffix: true)
      flags = aliases.map { |a| to_flag(a, false) }
      flags << flag(suffix:)

      flags
    end

    private

    def to_flag(flag_name, suffix)
      n = flag_name.gsub('_', '-')
      flag = if n.length == 1
               "-#{n}"
             elsif type == :boolean
               "--[no-]#{n}"
             else
               "--#{n}"
             end

      if suffix && banner
        flag << if banner.start_with?('=', ' ', '[=')
                  banner
                else
                  " #{banner}"
                end
      end

      flag
    end
  end
end

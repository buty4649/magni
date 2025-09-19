class Magni
  class Option
    attr_reader :name, :aliases, :banner, :default, :desc, :required, :type, :enum, :repeatable

    VALID_TYPES = %i[string numeric boolean flag].freeze

    def initialize(name, options = {})
      @name = name
      @type = options[:type] || :string
      @aliases = [options[:aliases]].flatten.compact
      @default = options[:default] || (true if @type == :boolean)
      @desc = options[:desc]
      @required = options[:required]
      @banner = options[:banner] || @type.to_s unless %i[boolean flag].include?(type)
      @enum = [options[:enum]].flatten.compact
      @repeatable = options[:repeatable]

      validate
    end

    def validate
      raise OptionTypeInvalidError, name unless VALID_TYPES.include?(type)
    end

    def self.build(name, options = {})
      new(name, options)
    end

    def self.flag(name, type = nil, suffix = nil)
      flag = name_to_flag(name, type)

      if suffix
        flag << if suffix.start_with?('=') || suffix.start_with?(' ') || suffix.start_with?('[=')
                  suffix
                else
                  " #{suffix}"
                end
      end

      flag
    end

    def self.name_to_flag(name, type)
      n = name.to_s.gsub('_', '-')
      if name.length == 1
        "-#{n}"
      elsif type == :boolean
        "--[no-]#{n}"
      else
        "--#{n}"
      end
    end
  end
end

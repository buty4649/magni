class Magni
  class Option
    attr_reader :name, :aliases, :banner, :default, :desc, :required, :type, :enum, :repeatable

    VALID_TYPES = %i[string numeric boolean].freeze

    def initialize(name, options = {})
      @name = name
      @aliases = [options[:aliases] || options[:alias]].flatten.compact
      @default = options[:default]
      @desc = options[:desc]
      @required = options[:required] || false
      @type = options[:type] || :string
      @banner = (options[:banner] || @type.to_s) if @type != :boolean
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
      flag = if name.length == 1
               "-#{name}"
             elsif type == :boolean
               "--[no-]#{name}"
             else
               "--#{name}"
             end

      if suffix
        flag << if suffix.start_with?('=') || suffix.start_with?(' ') || suffix.start_with?('[=')
                  suffix
                else
                  " #{suffix}"
                end
      end

      flag
    end
  end
end

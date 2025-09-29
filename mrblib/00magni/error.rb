class Magni
  class Error < StandardError; end

  class RequiredOptionError < Error
    def initialize(opt)
      super("#{opt} is required")
    end
  end

  class CommandNotFoundError < Error
    def initialize(command_name)
      super("command #{command_name} not found")
    end
  end

  class CommandArgumentError < Error
    def initialize(command, message)
      super("#{command.name}: #{message}")
    end
  end

  class OptionTypeInvalidError < Error
    def initialize(opt)
      super("#{opt} type must be one of: #{Option::VALID_TYPES.join(', ')}")
    end
  end

  class OptionAttributeInvalidError < Error
    def initialize(opt, attr)
      super("#{opt} #{attr} is invalid")
    end
  end

  class InvalidFormatError < Error; end

  class InvalidOptionError < Error
    def initialize(opt, enum)
      super("#{opt} must be one of: #{enum.join(', ')}")
    end
  end
end

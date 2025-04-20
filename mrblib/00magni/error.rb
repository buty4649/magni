class Magni
  class Error < StandardError; end

  class RequiredOptionError < Error
    def initialize(opt)
      super("Error: #{opt} is required")
    end
  end

  class CommandNotFoundError < Error
    def initialize(command_name)
      super("Error: command #{command_name} not found")
    end
  end

  class CommandArgumentError < Error
    def initialize(command, message)
      super("Error: #{command.name}: #{message}")
    end
  end

  class OptionTypeInvalidError < Error
    def initialize(opt)
      super("Error: #{opt} type must be one of: #{Option::VALID_TYPES.join(', ')}")
    end
  end

  class InvalidFormatError < Error; end

  class InvalidOptionError < Error
    def initialize(opt, enum)
      super("Error: #{opt} must be one of: #{enum.join(', ')}")
    end
  end
end

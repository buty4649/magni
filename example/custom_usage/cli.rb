class Cli < Magni
  app_name 'CustomUsageApp'

  # Custom usage message
  def self.usage(name, _command)
    <<~USAGE
      #{name} is a demonstration tool for custom usage messages.

      Usage:
        #{name} [options] <command> [arguments...]
        #{name} --version
        #{name} --help

      Examples:
        #{name} greet John          # Greet someone by name
        #{name} count --num 5       # Count to a specific number
        #{name} status              # Show application status
    USAGE
  end

  option :num, aliases: :n, type: :numeric, default: 3, desc: 'number to count to'
  desc 'count', 'count from 1 to specified number'
  def count
    (1..options[:num]).each { |i| puts i }
  end

  desc 'greet NAME', 'greet someone by name'
  def greet(name)
    puts "Hello, #{name}! Welcome to #{app_name}."
  end

  desc 'status', 'show application status'
  def status
    puts "Application: #{app_name}"
    puts 'Status: Running'
    puts 'This demonstrates custom usage formatting'
  end
end

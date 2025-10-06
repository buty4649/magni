class Cli < Magni
  app_name 'FailureExample'

  # Disable help display on failure
  def self.show_help_on_failure?
    false
  end

  option :count, aliases: :c, type: :numeric, desc: 'number to process'
  desc 'process', 'process with required count option'
  def process
    if options[:count].nil?
      puts 'Error: count option is required'
      exit 1
    end
    puts "Processing #{options[:count]} items"
  end

  desc 'divide NUM1 NUM2', 'divide two numbers'
  def divide(num1, num2)
    if num2.to_i.zero?
      puts 'Error: Division by zero is not allowed'
      exit 1
    end
    result = num1.to_f / num2.to_i
    puts "#{num1} / #{num2} = #{result}"
  end
end

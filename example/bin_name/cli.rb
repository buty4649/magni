class Cli < Magni
  app_name 'MyTool'

  option :message, aliases: :m, default: 'world', type: :string, desc: 'message to say'

  desc 'greet', 'greet someone'
  def greet
    puts "Hello #{options[:message]} from #{app_name}!"
  end

  desc 'info', 'show tool information'
  def info
    puts "Tool name: #{app_name}"
    puts 'Binary name: mytool'
    puts 'This demonstrates custom binary naming in Magni'
  end
end

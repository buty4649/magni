class Cli < Magni
  option :message, aliases: :m, default: 'world', type: :string, desc: 'message to say'

  desc 'hello', 'say hello message'
  def hello
    puts "hello #{options[:message]}"
  end

  desc 'greet', 'greet someone'
  def greet
    puts "greetings #{options[:message]}"
  end

  default_command :hello
end

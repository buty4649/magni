class Cli < Magni
  app_name 'MyAwesomeApp'

  option :message, aliases: :m, default: 'hello', type: :string, desc: 'message to say'
  desc 'hello', 'say hello message'
  def hello
    puts "hello #{options[:message]}"
  end

  desc 'info', 'show app information'
  def info
    puts "App name: #{app_name}"
    puts 'This is a basic example of Magni'
  end
end

class Cli < Magni
  class_option :banner, desc: 'banner', type: :string
  default_command :hello
  app_name 'magni-example'

  desc 'hello', 'say hello'
  option :desc, aliases: :d, default: 'desc', type: :string, desc: 'description', banner: 'string'
  option :color, aliases: :c, type: :boolean
  def hello(message)
    puts options[:banner] if options[:banner]

    print "\e[31m" if options[:color]
    puts "hello #{message}"
    puts "desc: #{options[:desc]}" if options[:desc]
    print "\e[m" if options[:color]
  end

  desc 'version', 'show version'
  def version
    puts options[:banner] if options[:banner]

    print_version
  end

  no_commands do
    def print_version
      puts "version #{MAGNI_VERSION}"
    end
  end
end

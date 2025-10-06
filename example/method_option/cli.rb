class Cli < Magni # rubocop:disable Metrics/ClassLength
  app_name 'MethodOptionApp'

  # String type options
  option :name, aliases: :n, type: :string, desc: 'your name'
  option :message, aliases: :m, type: :string, default: 'Hello', desc: 'greeting message'
  order 1
  desc 'string', 'demonstrate string type options'
  def string
    name = options[:name] || 'World'
    puts "#{options[:message]}, #{name}!"
  end

  # Numeric type options
  option :count, aliases: :c, type: :numeric, default: 5, desc: 'number to count to'
  option :step, aliases: :s, type: :numeric, default: 1, desc: 'step size'
  order 2
  desc 'numeric', 'demonstrate numeric type options'
  def numeric
    current = options[:step]
    while current <= options[:count]
      puts current
      current += options[:step]
    end
  end

  # Boolean type options
  option :verbose, aliases: :v, type: :boolean, desc: 'enable verbose output'
  option :force, aliases: :f, type: :boolean, desc: 'force operation'
  order 3
  desc 'boolean', 'demonstrate boolean type options'
  def boolean
    puts 'Processing...'
    puts "Verbose mode: #{options[:verbose] ? 'ON' : 'OFF'}"
    puts "Force mode: #{options[:force] ? 'ON' : 'OFF'}"

    if options[:verbose]
      puts '  - Step 1: Initializing...'
      puts '  - Step 2: Processing data...'
      puts '  - Step 3: Finalizing...'
    end

    puts 'Warning: Force mode enabled - skipping safety checks' if options[:force]

    puts 'Done!'
  end

  # Flag type options
  option :debug, aliases: :d, type: :flag, desc: 'enable debug mode'
  option :quiet, aliases: :q, type: :flag, desc: 'suppress output'
  order 4
  desc 'flag', 'demonstrate flag type options'
  def flag
    puts 'Flag demonstration:'
    puts "Debug mode: #{options[:debug] ? 'ON' : 'OFF'}"
    puts "Quiet mode: #{options[:quiet] ? 'ON' : 'OFF'}"

    if options[:debug] && !options[:quiet]
      puts 'Debug: Starting flag command execution'
      puts 'Debug: Checking flag states'
      puts 'Debug: All checks completed'
    end

    return if options[:quiet]

    puts 'Flag command executed successfully!'
  end

  # Repeatable options
  option :file, aliases: :f, type: :string, repeatable: true, desc: 'files to process (can be specified multiple times)'
  option :tag, aliases: :t, type: :string, repeatable: true, desc: 'tags to apply (can be specified multiple times)'
  order 5
  desc 'repeatable', 'demonstrate repeatable options'
  def repeatable
    files = options[:file] || []
    tags = options[:tag] || []

    puts "Files: #{files.join(', ')}" unless files.empty?
    puts "Tags: #{tags.join(', ')}" unless tags.empty?
    puts "Processing #{files.length} files with #{tags.length} tags"
  end

  # Display name options
  option :config_file, aliases: :c, type: :string, display_name: 'CONFIG', desc: 'configuration file path'
  option :output_dir, aliases: :o, type: :string, display_name: 'DIRECTORY', desc: 'output directory'
  option :max_threads, aliases: :t, type: :numeric, display_name: 'COUNT', desc: 'maximum number of threads'
  order 6
  desc 'display_name', 'demonstrate display_name option'
  def display_name
    puts "Configuration file: #{options[:config_file] || 'default.conf'}"
    puts "Output directory: #{options[:output_dir] || './output'}"
    puts "Max threads: #{options[:max_threads] || 1}"
  end

  # Banner options
  option :output, aliases: :o, type: :string, banner: 'FILE', desc: 'output file path'
  option :logfile, aliases: :l, type: :string, banner: '[LOGFILE]', desc: 'log file (optional)'
  option :workdir, aliases: :w, type: :string, banner: '[=DIR]', desc: 'working directory'
  order 7
  desc 'banner', 'demonstrate banner option'
  def banner
    puts "Output file: #{options[:output] || 'stdout'}"
    puts "Log file: #{options[:logfile] || 'none'}"
    puts "Working directory: #{options[:workdir] || Dir.pwd}"
  end

  # Required options
  option :name, aliases: :n, type: :string, required: true, desc: 'user name (required)'
  option :email, aliases: :e, type: :string, required: true, desc: 'email address (required)'
  order 8
  desc 'required', 'demonstrate required options'
  def required
    puts "Name: #{options[:name]}"
    puts "Email: #{options[:email]}"
    puts 'User registration completed!'
  end

  # Default options
  option :host, aliases: :h, type: :string, default: 'localhost', desc: 'server host'
  option :port, aliases: :p, type: :numeric, default: 8080, desc: 'server port'
  option :timeout, aliases: :t, type: :numeric, default: 30, desc: 'timeout in seconds'
  order 9
  desc 'default', 'demonstrate default options'
  def default
    puts "Connecting to #{options[:host]}:#{options[:port]}"
    puts "Timeout: #{options[:timeout]} seconds"
    puts 'Connection established!'
  end
end

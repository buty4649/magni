class Cli < Magni
  app_name 'FileManager'

  option :create, aliases: :c, type: :boolean, desc: 'create a new file'
  option :delete, aliases: :d, type: :boolean, desc: 'delete an existing file'
  option :update, aliases: :u, type: :boolean, desc: 'update an existing file'
  option :file, aliases: :f, type: :string, required: true, desc: 'target file path'

  desc 'manage', 'manage files with mutually exclusive options'
  exclude_options :create, :delete, :update
  def manage
    if options[:create]
      puts "Creating file: #{options[:file]}"
    elsif options[:delete]
      puts "Deleting file: #{options[:file]}"
    elsif options[:update]
      puts "Updating file: #{options[:file]}"
    else
      puts "Please specify one of: --create, --delete, or --update"
      exit 1
    end
  end

  option :read, aliases: :r, type: :boolean, desc: 'read mode'
  option :write, aliases: :w, type: :boolean, desc: 'write mode'
  option :verbose, aliases: :v, type: :boolean, desc: 'verbose output'

  desc 'access', 'access files with read/write exclusion'
  exclude_options %i[read write]
  def access
    mode = if options[:read]
             'reading'
           elsif options[:write]
             'writing'
           else
             puts "Please specify either --read or --write mode"
             exit 1
           end

    file = options[:file] || 'default.txt'
    message = "Accessing #{file} in #{mode} mode"
    message += " (verbose)" if options[:verbose]
    puts message
  end

  option :start, aliases: :s, type: :boolean, desc: 'start the service'
  option :stop, aliases: :t, type: :boolean, desc: 'stop the service'
  option :restart, aliases: :r, type: :boolean, desc: 'restart the service'
  option :foreground, aliases: :fg, type: :boolean, desc: 'run in foreground'
  option :daemon, aliases: :d, type: :boolean, desc: 'run as daemon'

  desc 'service', 'manage services with multiple exclusion groups'
  exclude_options :start, :stop, :restart    # Action group: only one action allowed
  exclude_options :foreground, :daemon       # Mode group: only one mode allowed
  def service
    action = if options[:start]
               'starting'
             elsif options[:stop]
               'stopping'
             elsif options[:restart]
               'restarting'
             else
               puts "Please specify an action: --start, --stop, or --restart"
               exit 1
             end

    mode = if options[:foreground]
             'in foreground'
           elsif options[:daemon]
             'as daemon'
           else
             'with default settings'
           end

    puts "Service #{action} #{mode}"
  end
end

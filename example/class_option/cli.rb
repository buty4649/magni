class Cli < Magni
  app_name 'ClassOptionApp'

  # Global class options - available for all commands
  class_option :verbose, aliases: :v, type: :boolean, desc: 'enable verbose output'
  class_option :config, aliases: :c, type: :string, desc: 'configuration file'
  class_option :dry_run, type: :flag, desc: 'show what would be done without executing'

  desc 'build', 'build the project'
  def build
    puts 'Building project...'
    puts "Config file: #{class_options[:config] || 'default.conf'}" if class_options[:verbose]
    puts 'Verbose mode: ON' if class_options[:verbose]

    if class_options[:dry_run]
      puts 'DRY RUN: Would compile source files'
      puts 'DRY RUN: Would create output directory'
    else
      puts 'Compiling source files...'
      puts 'Creating output directory...'
      puts 'Build completed!'
    end
  end

  desc 'test', 'run tests'
  def test
    puts 'Running tests...'
    puts "Config file: #{class_options[:config] || 'test.conf'}" if class_options[:verbose]
    puts 'Verbose mode: ON' if class_options[:verbose]

    if class_options[:dry_run]
      puts 'DRY RUN: Would run test suite'
    else
      puts 'Test suite passed!'
    end
  end

  desc 'deploy', 'deploy the application'
  def deploy
    puts 'Deploying application...'
    puts "Config file: #{class_options[:config] || 'deploy.conf'}" if class_options[:verbose]
    puts 'Verbose mode: ON' if class_options[:verbose]

    if class_options[:dry_run]
      puts 'DRY RUN: Would upload files to server'
      puts 'DRY RUN: Would restart services'
    else
      puts 'Uploading files to server...'
      puts 'Restarting services...'
      puts 'Deployment completed!'
    end
  end
end

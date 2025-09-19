if (mruby_dir = ENV.fetch('MRUBY_DIR', nil))
  unless File.exist?(File.join(mruby_dir, 'Rakefile'))
    raise "MRUBY_DIR is set to #{mruby_dir}, but #{mruby_dir}/Rakefile does not exist"
  end
else
  mruby_dir = File.join(__dir__, 'mruby')
  unless File.exist?(File.join(mruby_dir, 'Rakefile'))
    unless ENV['CI']
      print 'Do you want to clone mruby? [Y/n]: '
      answer = gets.chomp
      answer = 'Y' if answer.empty?

      raise 'mruby is required but not found' unless answer =~ /^[Yy]/
    end

    mruby_version = ENV.fetch('MRUBY_VERSION', 'master')
    if mruby_version =~ /^\d+\.\d+\.\d+$/
      puts "Download mruby #{mruby_version}..."
      system("wget https://github.com/mruby/mruby/archive/#{mruby_version}.zip -O mruby.zip")
      system('unzip mruby.zip')
      system("mv mruby-#{mruby_version} #{mruby_dir}")
      File.delete('mruby.zip')
    else
      puts 'Cloning mruby...'
      system("git clone https://github.com/mruby/mruby.git #{mruby_dir}")
    end
    raise 'Failed to clone mruby' unless File.exist?(File.join(mruby_dir, 'Rakefile'))

  end
end

ENV['MRUBY_CONFIG'] = ENV['MRUBY_CONFIG'] || File.join(__dir__, 'build_config.rb')
ENV['MRUBY_BUILD_DIR'] = ENV['MRUBY_BUILD_DIR'] || File.join(__dir__, 'build')
load File.join(mruby_dir, 'Rakefile')

desc 'run all tests with valgrind memory check'
task 'test:memcheck' => 'test:build' do
  sh 'valgrind --leak-check=full --error-exitcode=1 ./build/host/bin/mrbtest'
end

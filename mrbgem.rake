MRuby::Gem::Specification.new('magni') do |spec| # rubocop: disable Metrics/BlockLength
  spec.license = 'MIT'
  spec.author  = 'buty4649'
  spec.summary = 'A CLI framework for building powerful tools with mruby'
  spec.version = '1.1.2'

  config_dir = File.dirname(MRuby::Build.mruby_config_path)
  spec.rbfiles += Dir[
                    File.join(config_dir, '*.rb'),
                    File.join(config_dir, 'app', '**', '*.rb'),
                    File.join(config_dir, 'lib', '**', '*.rb'),
                    File.join(config_dir, 'mrblib', '**', '*.rb')
                  ].grep_v(/build_config.rb$/)

  spec.add_dependency('mruby-exit', core: 'mruby-exit')
  spec.add_dependency('mruby-io', core: 'mruby-io')
  spec.add_dependency('mruby-kernel-ext', core: 'mruby-kernel-ext')
  spec.add_dependency('mruby-method', core: 'mruby-method')
  spec.add_dependency('mruby-sprintf', core: 'mruby-sprintf')
  spec.add_dependency('mruby-tiny-optparse', github: 'buty4649/mruby-tiny-optparse', branch: 'main')

  spec.add_test_dependency('mruby-struct', core: 'mruby-struct')
  spec.add_test_dependency('mruby-test-stub', github: 'buty4649/mruby-test-stub', branch: 'main')

  build_config_initializer = spec.build_config_initializer
  spec.build_config_initializer = proc do
    instance_eval(&build_config_initializer) if build_config_initializer

    if spec.bins.empty? && !spec.build.defines.include?('MAGNI_NO_ENTRYPOINT')
      # Set the directory name containing build_config.rb to bin
      spec.bins << File.basename(File.absolute_path(config_dir))
    end

    spec.bins.each do |bin|
      objname = spec.build.objfile(bin.pathmap("#{spec.build_dir}/tools/#{spec.bins.first}/%n"))
      entrypoint = "#{spec.dir}/templates/entrypoint.c"
      exe = spec.build.exefile("#{build.build_dir}/bin/#{bin}")

      file exe => objname
      file objname => entrypoint do
        spec.build.cc.run objname, entrypoint
      end
    end
  end
end

MRuby::Build.new do |conf|
  conf.toolchain
  conf.gembox 'default'
  conf.gem File.join(__dir__, '..', '..') # magni gem
  conf.build_dir = File.join(__dir__, '..', '..', 'build')
end

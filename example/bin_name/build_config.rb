MRuby::Build.new do |conf|
  conf.toolchain
  conf.gembox 'default'
  conf.gem File.join(__dir__, '..', '..') do |g| # magni gem
    g.bins = %w[mytool]
  end
  conf.build_dir = File.join(__dir__, '..', '..', 'build')
end

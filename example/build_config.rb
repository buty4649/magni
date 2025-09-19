MRuby::Build.new do |conf|
  conf.toolchain
  # conf.gembox 'default'
  conf.gem core: 'mruby-io'
  conf.gem core: 'mruby-method'
  conf.gem core: 'mruby-sprintf'
  conf.gem core: 'mruby-exit'
  conf.gem '../' do |g|
    g.bins << 'magni-example'
  end

  conf.enable_debug
end

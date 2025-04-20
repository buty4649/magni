MRuby::Build.new do |conf|
  conf.toolchain

  conf.gem core: 'mruby-io'
  conf.gem core: 'mruby-method'
  conf.gem core: 'mruby-sprintf'
  conf.gem core: 'mruby-exit'
  conf.gem '.'

  conf.enable_test
  conf.enable_debug
end

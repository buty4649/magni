assert('Magni::Option#initialize and attributes') do
  opt = Magni::Option.new(:foo, {
                            aliases: %i[f bar],
                            default: 42,
                            desc: 'desc',
                            display_name: 'display_name',
                            required: true,
                            type: :numeric,
                            banner: 'BANNER',
                            enum: %w[a b],
                            repeatable: true
                          })
  assert_equal 'foo', opt.name
  assert_equal %w[f bar], opt.aliases
  assert_equal 42, opt.default
  assert_equal 'desc', opt.desc
  assert_equal 'display_name', opt.display_name
  assert_true opt.required
  assert_equal :numeric, opt.type
  assert_equal 'BANNER', opt.banner
  assert_equal %w[a b], opt.enum
  assert_true opt.repeatable
end

assert('Magni::Option#initialize with defaults') do
  opt = Magni::Option.new(:bar)
  assert_equal 'bar', opt.name
  assert_equal [], opt.aliases
  assert_nil opt.default
  assert_nil opt.desc
  assert_nil opt.display_name
  assert_nil opt.required
  assert_equal :string, opt.type
  assert_equal 'string', opt.banner
  assert_equal [], opt.enum
  assert_nil opt.repeatable

  opt = Magni::Option.new(:baz, type: :boolean)
  assert_nil opt.banner
end

assert('Magni::Option.build') do
  opt = Magni::Option.build(:baz, { type: :boolean })
  assert_equal 'baz', opt.name
  assert_equal :boolean, opt.type
end

assert('Magni::Option#flag generates correct flags') do
  opt_f = Magni::Option.new(:f)
  assert_equal '-f', opt_f.flag(suffix: false)

  opt_foo = Magni::Option.new(:foo)
  assert_equal '--foo', opt_foo.flag(suffix: false)

  opt_bool = Magni::Option.new(:foo, type: :boolean)
  assert_equal '--[no-]foo', opt_bool.flag(suffix: false)

  opt_string = Magni::Option.new(:foo, type: :string, banner: 'VAL')
  assert_equal '--foo', opt_string.flag(suffix: false)
  assert_equal '--foo VAL', opt_string.flag(suffix: true)
end

assert('Magni::Option#flag with special banner formats') do
  opt_equal = Magni::Option.new(:file, type: :string, banner: '=FILE')
  assert_equal '--file=FILE', opt_equal.flag(suffix: true)

  opt_space = Magni::Option.new(:output, type: :string, banner: ' OUTPUT')
  assert_equal '--output OUTPUT', opt_space.flag(suffix: true)

  opt_bracket = Magni::Option.new(:config, type: :string, banner: '[=CONFIG]')
  assert_equal '--config[=CONFIG]', opt_bracket.flag(suffix: true)

  opt_regular = Magni::Option.new(:name, type: :string, banner: 'NAME')
  assert_equal '--name NAME', opt_regular.flag(suffix: true)
end

assert('Magni::Option#flag uses display_name when available') do
  opt = Magni::Option.new(:verbose, display_name: 'v')
  assert_equal '-v', opt.flag(suffix: false)
end

assert('Magni::Option#flags generates array of flags with aliases') do
  opt = Magni::Option.new(:verbose, aliases: ['v'], type: :boolean)
  flags = opt.flags(suffix: false)

  assert_true flags.is_a?(Array)
  assert_equal 2, flags.length
  assert_equal '-v', flags[0]
  assert_equal '--[no-]verbose', flags[1]
end

assert('Magni::Option#flags includes main flag and aliases') do
  opt = Magni::Option.new(:count, aliases: %w[c num], type: :numeric)
  flags = opt.flags(suffix: false)

  assert_equal 3, flags.length
  assert_equal '-c', flags[0]
  assert_equal '--num', flags[1]
  assert_equal '--count', flags[2]
end

assert('Magni::Option#flags with suffix applies only to main flag') do
  opt = Magni::Option.new(:output, aliases: :o, type: :string, banner: 'FILE')
  flags = opt.flags(suffix: true)

  assert_equal 2, flags.length
  assert_equal '-o', flags[0]
  assert_equal '--output FILE', flags[1]
end

assert('Magni::Option#flags handles empty aliases') do
  opt = Magni::Option.new(:verbose, type: :boolean)
  flags = opt.flags(suffix: false)

  assert_equal 1, flags.length
  assert_equal '--[no-]verbose', flags[0]
end

assert('Magni::Option#flags uses display_name instead of name') do
  opt = Magni::Option.new(:verbose_mode, aliases: ['v'], display_name: 'verbose', type: :boolean)
  flags = opt.flags(suffix: false)

  assert_equal 2, flags.length
  assert_equal '-v', flags[0]
  assert_equal '--[no-]verbose', flags[1]
end

assert('Magni::Option#validate raises on invalid type') do
  err = false
  begin
    Magni::Option.new(:bad, type: :invalid)
  rescue StandardError => e
    err = e.class.to_s.include?('OptionTypeInvalidError')
  end
  assert_true err
end

assert('Magni::Option.build with valid options') do
  opt = Magni::Option.build(:test, type: :string, desc: 'test option')
  assert_equal 'test', opt.name
  assert_equal :string, opt.type
  assert_equal 'test option', opt.desc
end

assert('Magni::Option.build raises on invalid attribute') do
  assert_raise(Magni::OptionAttributeInvalidError) do
    Magni::Option.build(:test, invalid_attr: 'value')
  end
end

assert('Magni::Option.build raises on multiple invalid attributes') do
  assert_raise(Magni::OptionAttributeInvalidError) do
    Magni::Option.build(:test, bad_attr: 'value', another_bad: 'value2')
  end
end

assert('Magni::Option.build accepts all valid attributes') do
  opt = Magni::Option.build(:test, {
                              aliases: :t,
                              banner: 'BANNER',
                              default: 'default_val',
                              desc: 'description',
                              display_name: 'display',
                              required: true,
                              type: :string,
                              enum: %w[a b],
                              repeatable: false
                            })

  assert_equal 'test', opt.name
  assert_equal ['t'], opt.aliases
  assert_equal 'BANNER', opt.banner
  assert_equal 'default_val', opt.default
  assert_equal 'description', opt.desc
  assert_equal 'display', opt.display_name
  assert_true opt.required
  assert_equal :string, opt.type
  assert_equal %w[a b], opt.enum
  assert_false opt.repeatable
end

assert('Magni::Option.new accepts string as name') do
  opt = Magni::Option.new('debug', type: :boolean, desc: 'enable debug mode')
  assert_equal 'debug', opt.name
  assert_equal :boolean, opt.type
  assert_equal 'enable debug mode', opt.desc
end

assert('Magni::Option.build accepts string as name') do
  opt = Magni::Option.build('input', type: :string, banner: 'PATH')
  assert_equal 'input', opt.name
  assert_equal :string, opt.type
  assert_equal 'PATH', opt.banner
end

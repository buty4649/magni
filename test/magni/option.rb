assert('Magni::Option#initialize and attributes') do
  opt = Magni::Option.new('foo', {
                            aliases: %w[f bar],
                            default: 42,
                            desc: 'desc',
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
  assert_true opt.required
  assert_equal :numeric, opt.type
  assert_equal 'BANNER', opt.banner
  assert_equal %w[a b], opt.enum
  assert_true opt.repeatable
end

assert('Magni::Option#initialize with defaults') do
  opt = Magni::Option.new('bar')
  assert_equal 'bar', opt.name
  assert_equal [], opt.aliases
  assert_nil opt.default
  assert_nil opt.desc
  assert_nil opt.required
  assert_equal :string, opt.type
  assert_equal 'string', opt.banner
  assert_equal [], opt.enum
  assert_nil opt.repeatable
end

assert('Magni::Option.build') do
  opt = Magni::Option.build('baz', { type: :boolean })
  assert_equal 'baz', opt.name
  assert_equal :boolean, opt.type
end

assert('Magni::Option.flag') do
  assert_equal '-f', Magni::Option.flag('f')
  assert_equal '--foo', Magni::Option.flag('foo')
  assert_equal '-f', Magni::Option.flag('f')
  assert_equal '--[no-]foo', Magni::Option.flag('foo', :boolean)
  assert_equal '--foo', Magni::Option.flag('foo', :string)
  assert_equal '--foo=VAL', Magni::Option.flag('foo', :string, '=VAL')
  assert_equal '--foo [VAL]', Magni::Option.flag('foo', :string, '[VAL]')
  assert_equal '--foo[=VAL]', Magni::Option.flag('foo', :string, '[=VAL]')
  assert_equal '--foo =VAL', Magni::Option.flag('foo', :string, ' =VAL')
end

assert('Magni::Option#validate raises on invalid type') do
  err = false
  begin
    Magni::Option.new('bad', type: :invalid)
  rescue StandardError => e
    err = e.class.to_s.include?('OptionTypeInvalidError')
  end
  assert_true err
end

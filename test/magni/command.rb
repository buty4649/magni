assert('Magni::Command#initialize and attributes') do
  opts = [1, 2, 3]
  cmd = Magni::Command.new('foo', 'usage', 'desc', opts)
  assert_equal 'foo', cmd.name
  assert_equal 'usage', cmd.usage
  assert_equal 'desc', cmd.description
  assert_equal opts, cmd.options
end

assert('Magni::Command#initialize with nil options') do
  cmd = Magni::Command.new('bar', 'u', 'd', nil)
  assert_equal [], cmd.options
end

assert('Magni::Command#parser returns OptionParser') do
  mock = Object.new
  stub = ->(*) { mock }

  Magni::OptionParser.stub(:new, stub) do
    test = Magni::Command.new(:dummy, 'usage', 'description', [])
    assert_equal test.parser, mock
  end
end

assert('Magni::Command#help returns parser.help') do
  mock = Class.new do
    def help = 'helptext'
  end
  stub = ->(*) { mock.new }

  Magni::OptionParser.stub(:new, stub) do
    test = Magni::Command.new(:dummy, 'usage', 'description', [])
    assert_equal test.parser.help, 'helptext'
  end
end

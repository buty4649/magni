assert('Magni::Command#initialize and attributes') do
  opts = [1, 2, 3]
  cmd = Magni::Command.new({
                             name: 'foo',
                             usage: 'usage',
                             description: 'desc',
                             order: 10,
                             options: opts
                           })
  assert_equal 'foo', cmd.name
  assert_equal 'usage', cmd.usage
  assert_equal 'desc', cmd.description
  assert_equal 10, cmd.order
  assert_equal opts, cmd.options
end

assert('Magni::Command#initialize with nil options') do
  cmd = Magni::Command.new({
                             name: 'bar',
                             usage: 'u',
                             description: 'd',
                             order: nil,
                             options: nil
                           })
  assert_equal 0, cmd.order
  assert_equal [], cmd.options
end

assert('Magni::Command#parser returns OptionParser') do
  mock = Object.new
  stub = ->(*) { mock }

  Magni::OptionParser.stub(:new, stub) do
    test = Magni::Command.new({
                                name: :dummy,
                                usage: 'usage',
                                description: 'description',
                                order: 0,
                                options: []
                              })
    assert_equal test.parser, mock
  end
end

assert('Magni::Command#help returns parser.help') do
  mock = Class.new do
    def help = 'helptext'
  end
  stub = ->(*) { mock.new }

  Magni::OptionParser.stub(:new, stub) do
    test = Magni::Command.new({
                                name: :dummy,
                                usage: 'usage',
                                description: 'description',
                                order: 0,
                                options: []
                              })
    assert_equal test.parser.help, 'helptext'
  end
end

assert('Magni::Base::MethodOptions.desc sets usage and description') do
  klass = Class.new do
    extend Magni::Base::MethodOptions

    def self.usage_val = @usage
    def self.description_val = @description
  end
  klass.desc('USAGE', 'DESCRIPTION')
  assert_equal 'USAGE', klass.usage_val
  assert_equal 'DESCRIPTION', klass.description_val
end

assert('Magni::Base::MethodOptions.option adds an option') do
  klass = Class.new do
    extend Magni::Base::MethodOptions
  end
  klass.option('foo', type: :boolean)
  assert_true(klass.options.any? { |opt| opt.name == :foo && opt.type == :boolean })
end

assert('Magni::Base::MethodOptions.order sets order value') do
  klass = Class.new do
    extend Magni::Base::MethodOptions

    def self.order_val = @order
  end
  klass.order(5)
  assert_equal 5, klass.order_val
end

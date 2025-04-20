class Magni
  extend Base::ClassMethods
  include Base::Methods

  attr_accessor :options

  def initialize
    @options = {}

    Magni.current = self
  end
end

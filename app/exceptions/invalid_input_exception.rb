class InvalidInputException < StandardError
  attr_reader :attribute

  def initialize(attribute)
    @attribute = attribute
  end
end

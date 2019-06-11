class InvalidInputException < StandardError
  attr_reader :attribute

  def initialize(message, attribute)
    @attribute = attribute
    super(message)
  end
end

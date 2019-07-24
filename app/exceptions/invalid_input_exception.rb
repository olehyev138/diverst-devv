class InvalidInputException < StandardError
  attr_reader :message, :attribute

  def initialize(exception)
    @message = exception[:message]
    @attribute = exception[:attribute]
  end
end

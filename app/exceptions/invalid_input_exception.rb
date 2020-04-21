class InvalidInputException < StandardError
  attr_reader :message, :attribute, :errors

  def initialize(exception)
    @message = exception[:message]
    @attribute = exception[:attribute]
    @errors = exception[:errors]
  end
end

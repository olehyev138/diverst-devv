class Api::V1::MentorshipSessionsController < DiverstController
  def accept
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.accept
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def decline
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.decline
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end
end

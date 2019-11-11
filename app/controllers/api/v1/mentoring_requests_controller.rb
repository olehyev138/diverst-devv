class Api::V1::MentoringRequestsController < DiverstController
  def accept
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.accept(self.diverst_request)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def reject
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.reject
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end
end

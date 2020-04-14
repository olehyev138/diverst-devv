class Api::V1::BudgetItemsController < DiverstController
  def index
    base_authorize(klass)
    event = Initiative.find(params[:event_id]) if params[:event_id].present?

    render status: 200, json: klass.index(self.diverst_request, params.permit!, policy: @policy), event: event
  rescue => e
    case e
    when Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def close_budget
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.close(self.diverst_request)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end
end

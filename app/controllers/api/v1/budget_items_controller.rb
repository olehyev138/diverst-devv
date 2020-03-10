class Api::V1::BudgetItemsController < DiverstController
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

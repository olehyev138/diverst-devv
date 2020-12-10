class Api::V1::BudgetUsersController < DiverstController
  private def base
    super.with_expenses
  end

  def index
    type, id =
      if params[:initiative_id].present?
        ['Initiative', params[:initiative_id]]
      else
        raise BadRequestException.new('Need initiative_id')
      end
    params[:initiative_id] = nil
    params[:budgetable_id] = id
    params[:budgetable_type] = type
    diverst_request.options[:with_budget] = true
    super
  end

  def finish_expenses
    item = show_base.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.finalize_expenses(self.diverst_request)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end
end

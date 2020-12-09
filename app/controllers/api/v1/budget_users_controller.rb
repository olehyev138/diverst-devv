class Api::V1::BudgetUsersController < DiverstController
  private def index_base
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
end

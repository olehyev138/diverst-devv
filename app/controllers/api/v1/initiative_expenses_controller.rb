class Api::V1::InitiativeExpensesController < DiverstController
  def create
    type, id =
      if params[:initiative_expense][:initiative_id].present?
        ['Initiative', params[:initiative_expense][:initiative_id]]
      else
        raise BadRequestException.new('Need initiative_id')
      end
    params[:initiative_expense][:budget_user_id] = BudgetUser.select(:id).find_by(
      budgetable_id: id,
      budgetable_type: type,
      budget_item_id: params[:initiative_expense][:budget_item_id]
    )&.id
    params[:initiative_expense][:owner_id] = current_user.id
    super
  end

  def payload
    params
      .require(:initiative_expense)
      .permit(
        :description,
        :amount,
        :budget_user_id,
      )
  end

end

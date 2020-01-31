class Api::V1::InitiativeExpensesController < DiverstController
  def create
    params[:initiative_expense][:owner_id] = current_user.id
    super
  end
end

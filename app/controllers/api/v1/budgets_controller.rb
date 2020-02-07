class Api::V1::BudgetsController < DiverstController
  def payload
    params
        .require(:budget)
        .permit(
            :description,
            :approver_id,
            :annual_budget_id,
            :requester_id,
            budget_items_attributes: [
                :title,
                :estimated_amount,
                :estimated_date,
                :is_private,
            ],
          )
  end

  def create
    params[:budget][:budget_items_attributes] = params[:budget][:budget_items]
    params[:budget][:requester_id] = current_user.id
    params[:budget].delete(:budget_items)
    super
  end

  def approve
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.approve(current_user)
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

    decline_reason = params[:budget][:decline_reason]
    render status: 200, json: item.decline(current_user, decline_reason)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end
end

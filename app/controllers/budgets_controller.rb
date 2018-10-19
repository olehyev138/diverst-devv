class BudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_budget, only: [:show, :approve, :decline, :destroy]

  layout 'budgets'

  def index
    authorize @group, :budgets?
    @budgets = @group.budgets.order("id DESC")
  end

  def show
    authorize @group, :view_budget?
  end

  def new
    authorize @group, :request_budget?

    @budget = Budget.new
  end

  def create
    authorize @group, :submit_budget?

    @budget = Budget.new(budget_params.merge({ requester_id: current_user.id }))
    @group.budgets << @budget

    if @group.save
      flash[:notice] = "Your budget was created"
      track_activity(@budget, :create)
      redirect_to action: :index
    else
      flash[:alert] = "Your budget was not created. Please fix the errors"
      render :new
    end
  end

  def approve
    authorize @budget, :approve?
    if @budget.update(budget_params)
      BudgetManager.new(@budget).approve(current_user)
      track_activity(@budget, :approve)
      redirect_to action: :index
    else
      redirect_to :back
    end
  end

  def decline
    authorize @budget, :decline?

    @budget.decline_reason = params[:decline_reason]
    @budget.save

    BudgetManager.new(@budget).decline(current_user)
    track_activity(@budget, :decline)

    redirect_to action: :index
  end

  def destroy
    authorize @group, :submit_budget?
    track_activity(@budget, :destroy)
    if @budget.destroy
      flash[:notice] = "Your budget was deleted"
      redirect_to action: :index
    else
      flash[:alert] = "Your budget was not deleted. Please fix the errors"
      redirect_to :back
    end
  end

  def export_csv
    authorize @group, :request_budget?

    result =
      CSV.generate do |csv|
        csv << ['Requested amount', 'Available amount', 'Status', 'Requested at', '# of events', 'Description']
         @group.budgets.order(created_at: :desc).each do |budget|
          csv << [budget.requested_amount, budget.available_amount, budget.status_title, budget.created_at, budget.budget_items.count, budget.description]
        end
      end
    send_data result, filename: @group.file_safe_name.downcase + '_budgets.csv'
  end

  def edit_annual_budget
    authorize @group.enterprise, :update?
  end

  def reset_annual_budget
    authorize @group.enterprise, :update?

    if @group.update({:annual_budget => 0, :leftover_money => 0})
      @group.budgets.update_all(:is_approved => false)
      track_activity(@group, :annual_budget_update)
      flash[:notice] = "Your budget was updated"
      redirect_to :back
    else
      flash[:alert] = "Your budget was not updated. Please fix the errors"
      redirect_to :back
    end
  end

  def carry_over_annual_budget
    authorize @group.enterprise, :update?

    leftover = @group.leftover_money + @group.annual_budget

    if @group.update({:annual_budget => leftover, :leftover_money => 0})
      @group.budgets.update_all(:is_approved => false)
      track_activity(@group, :annual_budget_update)
      flash[:notice] = "Your budget was updated"
      redirect_to :back
    else
      flash[:alert] = "Your budget was not updated. Please fix the errors"
      redirect_to :back
    end
  end

  def update_annual_budget
    authorize @group.enterprise, :update?

    if @group.update(annual_budget_params)
      track_activity(@group, :annual_budget_update)
      flash[:notice] = "Your budget was updated"
      redirect_to :back
    else
      flash[:alert] = "Your budget was not updated. Please fix the errors"
      redirect_to :back
    end
  end

  private

  def set_group
    if current_user
      @group = current_user.enterprise.groups.find(params[:group_id])
    else
      user_not_authorized
    end
  end

  def set_budget
    @budget = Budget.find(params[:id] || params[:budget_id])
  end

  def budget_params
    params
      .require(:budget)
      .permit(
        :description,
        :comments,
        :approver_id,
        budget_items_attributes: [
          :id,
          :title,
          :estimated_amount,
          :estimated_date,
          :is_private,
          :is_done,
          :_destroy
        ]
      )
  end

  def annual_budget_params
    params
      .require(:group)
      .permit(
        :annual_budget,
        :leftover_money
      )
  end
end

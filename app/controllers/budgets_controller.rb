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
      redirect_to action: :index
    else
      flash[:alert] = "Your budget was not created. Please fix the errors"
      render :new
    end
  end

  def approve
    authorize @budget, :approve?

    BudgetManager.new(@budget).approve(current_user)

    redirect_to action: :index
  end

  def decline
    authorize @budget, :decline?
    BudgetManager.new(@budget).decline(current_user)

    redirect_to action: :index
  end

  def destroy
    authorize @group, :submit_budget?
    if @budget.destroy
      flash[:notice] = "Your budget was deleted"
      redirect_to action: :index
    else
      flash[:alert] = "Your budget was not deleted. Please fix the errors"
      redirect_to :back
    end
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
      Logger.new("#{Rails.root}/log/my.log").info(@group.annual_budget)
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
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_budget
    @budget = Budget.find(params[:id] || params[:budget_id])
  end

  def budget_params
    params
      .require(:budget)
      .permit(
        :description,
        :approver_id,
        budget_items_attributes: [
          :id,
          :title,
          :estimated_amount,
          :estimated_date,
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

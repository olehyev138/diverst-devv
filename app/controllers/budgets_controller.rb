class BudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_budget, only: [:show, :approve, :decline, :destroy]
  after_action :visit_page, only: [:index, :show, :new, :edit_annual_budget]

  layout 'erg'

  def index
    authorize [@group], :index?, policy_class: GroupBudgetPolicy

    annual_budget = current_user.enterprise.annual_budgets.find_by(id: params[:annual_budget_id])
    @budgets = annual_budget&.budgets&.order('id DESC') || Budget.none
  end

  def show
    authorize [@group], :show?, policy_class: GroupBudgetPolicy
    @annual_budget_id = params[:annual_budget_id]
  end

  def new
    authorize [@group], :create?, policy_class: GroupBudgetPolicy

    if @group.annual_budgets.find(params[:annual_budget_id])&.amount == 0
      redirect_to(:back, alert: 'Annual Budget is not set for this group. Please check back later.')
    end

    @annual_budget_id = params[:annual_budget_id]
    @budget = Budget.new
  end

  def create
    authorize [@group], :create?, policy_class: GroupBudgetPolicy

    @budget = Budget.new(budget_params.merge({ requester_id: current_user.id }))
    @group.budgets << @budget

    annual_budget = current_user.enterprise.annual_budgets.find_or_create_by(closed: false, group_id: @group.id)
    annual_budget.budgets << @budget

    if @group.save
      flash[:notice] = 'Your budget was created'
      track_activity(@budget, :create)
      redirect_to(action: :index, annual_budget_id: params[:budget][:annual_budget_id])
    else
      flash[:alert] = 'Your budget was not created. Please fix the errors'
      @annual_budget_id = params[:budget][:annual_budget_id]
      render :new
    end
  end

  def approve
    authorize [@group], :approve?, policy_class: GroupBudgetPolicy

    if @group.annual_budget == 0 || @group.annual_budget.nil?
      flash[:alert] = 'please set an annual budget for this group'
      redirect_to :back
    else
      if @budget.budget_items.sum(:estimated_amount) > @budget.annual_budget.amount
        flash[:alert] = "This budget exceeds the annual budget of #{ActionController::Base.helpers.number_to_currency(@budget.annual_budget.amount)} and therefore cannot be approved"
        redirect_to :back
      else
        if @budget.update(budget_params)
          BudgetManager.new(@budget).approve(current_user)
          track_activity(@budget, :approve)
          redirect_to(action: :index, annual_budget_id: params[:budget][:annual_budget_id])
        else
          redirect_to :back
        end
      end
    end
  end

  def decline
    authorize [@group], :approve?, policy_class: GroupBudgetPolicy

    @budget.decline_reason = params[:decline_reason]
    @budget.save

    BudgetManager.new(@budget).decline(current_user)
    track_activity(@budget, :decline)

    redirect_to action: :index
  end

  def destroy
    authorize [@group, @budget], :destroy?, policy_class: GroupBudgetPolicy
    track_activity(@budget, :destroy)
    if @budget.destroy
      flash[:notice] = 'Your budget was deleted'
      redirect_to(action: :index, annual_budget_id: params[:annual_budget_id])
    else
      flash[:alert] = 'Your budget was not deleted. Please fix the errors'
      redirect_to :back
    end
  end

  def export_csv
    authorize [@group], :index?, policy_class: GroupBudgetPolicy
    GroupBudgetsDownloadJob.perform_later(current_user.id, @group.id)
    track_activity(@group, :export_budgets)
    flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
    redirect_to :back
  end

  def edit_annual_budget
    authorize [@group], :update?, policy_class: GroupBudgetPolicy
  end

  def reset_annual_budget
    authorize [@group], :update?, policy_class: GroupBudgetPolicy

    if AnnualBudgetManager.new(@group).reset!
      track_activity(@group, :annual_budget_update)
      flash[:notice] = 'Your budget was updated'
      redirect_to :back
    else
      flash[:alert] = 'Your budget was not updated.'
      redirect_to :back
    end
  end

  def carry_over_annual_budget
    authorize [@group], :update?, policy_class: GroupBudgetPolicy

    if AnnualBudgetManager.new(@group).carry_over!
      track_activity(@group, :annual_budget_update)
      flash[:notice] = 'Your budget was updated'
      redirect_to :back
    else
      flash[:alert] = 'Your budget was not updated.'
      redirect_to :back
    end
  end

  def update_annual_budget
    authorize [@group], :update?, policy_class: GroupBudgetPolicy

    if AnnualBudgetManager.new(@group).edit(annual_budget_params)
      track_activity(@group, :annual_budget_update)
      flash[:notice] = 'Your budget was updated'
      redirect_to :back
    else
      flash[:alert] = 'Your budget was not updated.'
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
        :comments,
        :approver_id,
        :annual_budget_id,
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@group.to_label}'s Budgets"
    when 'show'
      @budget.to_label.present? ? "Budget: #{@budget.to_label}" : 'Budget Info'
    when 'new'
      "#{@group.to_label}'s Budget Creation"
    when 'edit_annual_budget'
      "#{@group.to_label}'s Annual Budget Editor"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end

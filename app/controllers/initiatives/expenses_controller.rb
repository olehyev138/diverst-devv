class Initiatives::ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_initiative
  before_action :set_expense, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize InitiativeExpense
    visit_page("#{@initiative.name}'s Expenses")
    @expenses = @initiative.expenses

    redirect_to :back if @initiative.has_no_estimated_funding?
  end

  def new
    authorize InitiativeExpense
    visit_page("#{@initiative.name}'s Expense Creation")
    @expense = @initiative.expenses.new
  end

  def create
    authorize InitiativeExpense
    @expense = @initiative.expenses.new(expense_params)
    @expense.owner = current_user

    if @initiative.has_no_estimated_funding?
      flash[:alert] = 'you are not allowed to create a negative expense'
      render :new
    else
      annual_budget = current_user.enterprise.annual_budgets.find_or_create_by(closed: false, group_id: @group.id)
      annual_budget.initiative_expenses << @expense

      if @expense.save
        flash[:notice] = 'Your expense was created'
        redirect_to action: :index
      else
        flash[:alert] = 'Your expense was not created. Please fix the errors'
        render :new
      end
    end
  end

  def time_series
    authorize InitiativeExpense, :index?

    respond_to do |format|
      format.json {
        data = @initiative.expenses_highcharts_history(
          from: params[:from] ? Time.at(params[:from].to_i / 1000) : 1.year.ago,
          to: params[:to] ? Time.at(params[:to].to_i / 1000) : Time.current
        )

        render json: {
          highcharts: [{
            name: 'Expenses',
            data: data
          }]
        }
      }
      format.csv {
        InitiativeExpensesTimeSeriesDownloadJob.perform_later(current_user.id, @initiative.id, params[:from], params[:to])
        flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
        redirect_to :back
      }
    end
  end

  # MISSING TEMPLATE
  def show
    authorize @expense
    visit_page("View Expense #{@expense.name}")
  end

  def edit
    authorize @expense
    visit_page("Edit an Expense for #{@initiative.name}")
  end

  def update
    authorize @expense
    if @expense.update(expense_params)
      flash[:notice] = 'Your expense was updated'
      redirect_to action: :index
    else
      flash[:alert] = 'Your expense was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @expense
    @expense.destroy
    redirect_to action: :index
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_initiative
    @initiative = @group.initiatives.find(params[:initiative_id])
  end

  def set_expense
    @expense = @initiative.expenses.find(params[:id])
  end

  def expense_params
    params
      .require(:initiative_expense)
      .permit(
        :description,
        :amount,
        :annual_budget_id
      )
  end
end

class Initiatives::ExpensesController < ApplicationController
  before_action :set_group
  before_action :set_initiative
  before_action :set_expense, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'plan'

  def index
    authorize InitiativeExpense
    @expenses = @initiative.expenses
  end

  def new
    authorize InitiativeExpense
    @expense = @initiative.expenses.new
  end

  def create
    authorize InitiativeExpense
    @expense = @initiative.expenses.new(expense_params)
    @expense.owner = current_user

    if @expense.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def time_series
    authorize InitiativeExpense, :index?

    highcharts_data = @initiative.expenses_highcharts_history(
      from: params[:from] ? Time.at(params[:from].to_i / 1000) : 1.year.ago,
      to: params[:to] ? Time.at(params[:to].to_i / 1000) : Time.current
    )

    render json: highcharts_data
  end

  def show
    authorize @expense
  end

  def edit
    authorize @expense
  end

  def update
    authorize @expense
    if @expense.update(expense_params)
      redirect_to action: :index
    else
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
        :amount
      )
  end
end

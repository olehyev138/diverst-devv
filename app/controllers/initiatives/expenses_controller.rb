class Initiatives::ExpensesController < ApplicationController
  before_action :authenticate_user!
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
      flash[:notice] = "Your expense was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your expense was not created. Please fix the errors"
      render :new
    end
  end

  def time_series
    authorize InitiativeExpense, :index?

    data = @initiative.expenses_highcharts_history(
      from: params[:from] ? Time.at(params[:from].to_i / 1000) : 1.year.ago,
      to: params[:to] ? Time.at(params[:to].to_i / 1000) : Time.current
    )
    respond_to do |format|
      format.json {
        render json: {
          highcharts: [{
            name: "Expenses",
            data: data
          }]
        }
      }
      format.csv {
        strategy = Reports::GraphTimeseriesGeneric.new(title: 'Expenses over time', data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "expenses.csv"
      }
    end
  end

  # MISSING TEMPLATE
  def show
    authorize @expense
  end

  def edit
    authorize @expense
  end

  def update
    authorize @expense
    if @expense.update(expense_params)
      flash[:notice] = "Your expense was updated"
      redirect_to action: :index
    else
      flash[:alert] = "Your expense was not updated. Please fix the errors"
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

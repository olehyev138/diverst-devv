class ExpensesController < ApplicationController
  before_action :set_expense, only: [:edit, :update, :destroy, :show, :export_csv]
  after_action :verify_authorized

  layout 'collaborate'

  def index
    authorize Expense
    @expenses = policy_scope(Expense)
  end

  def new
    authorize Expense
    @expense = current_user.enterprise.expenses.new
  end

  def create
    authorize Expense
    @expense = current_user.enterprise.expenses.new(expense_params)

    if @expense.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def edit
    authorize @expense
  end

  def update
    authorize @expense
    if @expense.update(expense_params)
      redirect_to @expense
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

  def set_expense
    @expense = current_user.enterprise.expenses.find(params[:id])
  end

  def expense_params
    params
      .require(:expense)
      .permit(
        :name,
        :price,
        :category
      )
  end
end

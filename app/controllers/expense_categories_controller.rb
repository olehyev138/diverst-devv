class ExpenseCategoriesController < ApplicationController
  before_action :set_expense_category, only: [:edit, :update, :destroy, :show, :export_csv]
  after_action :verify_authorized

  layout 'collaborate'

  def index
    authorize ExpenseCategory
    @expense_categories = policy_scope(ExpenseCategory)
  end

  def new
    authorize ExpenseCategory
    @expense_category = current_user.enterprise.expense_categories.new
  end

  def create
    authorize ExpenseCategory
    @expense_category = current_user.enterprise.expense_categories.new(expense_params)

    if @expense_category.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def edit
    authorize @expense_category
  end

  def update
    authorize @expense_category
    if @expense_category.update(expense_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    authorize @expense_category
    @expense_category.destroy
    redirect_to action: :index
  end

  protected

  def set_expense_category
    @expense_category = current_user.enterprise.expense_categories.find(params[:id])
  end

  def expense_params
    params
      .require(:expense_category)
      .permit(
        :name,
        :price,
        :category,
        :income,
        :icon
      )
  end
end

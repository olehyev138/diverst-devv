class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:edit, :update, :destroy, :show, :export_csv]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :edit]

  layout 'collaborate'

  def index
    authorize Expense
    @expenses = policy_scope(Expense).includes(:category)
  end

  def new
    authorize Expense
    @expense = current_user.enterprise.expenses.new
  end

  def create
    authorize Expense
    @expense = current_user.enterprise.expenses.new(expense_params)
    if @expense.save
      flash[:notice] = 'Your expense was created'
      track_activity(@expense, :create)
      redirect_to action: :index
    else
      flash[:alert] = 'Your expense was not created. Please fix the errors'
      render :new
    end
  end

  def edit
    authorize @expense
  end

  def update
    authorize @expense
    if @expense.update(expense_params)
      flash[:notice] = 'Your expense was updated'
      track_activity(@expense, :update)
      redirect_to action: :index
    else
      flash[:alert] = 'Your expense was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @expense
    track_activity(@expense, :destroy)
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
          :category_id,
          :income
        )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Expenses'
    when 'new'
      'Expense Creation'
    when 'edit'
      "Expense Edit: #{@expense.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end

class ExpenseCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense_category, only: [:edit, :update, :destroy, :show, :export_csv]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :edit]

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
      flash[:notice] = 'Your expense category was created'
      track_activity(@expense_category, :create)
      redirect_to action: :index
    else
      flash[:alert] = 'Your expense category was not created. Please fix the errors'
      render :new
    end
  end

  def edit
    authorize @expense_category
  end

  def update
    authorize @expense_category
    if @expense_category.update(expense_params)
      flash[:notice] = 'Your expense category was updated'
      track_activity(@expense_category, :update)
      redirect_to action: :index
    else
      flash[:alert] = 'Your expense category was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @expense_category
    track_activity(@expense_category, :destroy)
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Expense Categories'
    when 'new'
      'Expense Category Creation'
    when 'edit'
      "Expense Category Edit: #{@expense_category.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end

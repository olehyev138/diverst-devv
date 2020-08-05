class DepartmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_department, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'collaborate'

  def index
    authorize Department
    @departments = policy_scope(Department)
  end

  def new
    authorize Department
    @department = current_user.enterprise.departments.new
  end

  def create
    authorize Department
    @department = current_user.enterprise.departments.new(department_params)

    if @department.save 
      flash[:notice] = 'Your department was created'
      redirect_to action: :index
    else
      flash[:alert] = 'Your department was not created. Please fix the errors'
      render :new
    end
  end

  def edit
    authorize @department
  end

  def update
    authorize @department
    if @department.update(department_params)
      flash[:notice] = 'Your department was updated'
      redirect_to action: :index
    else
      flash[:alert] = 'Your department was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @department
    @department.destroy
    redirect_to action: :index
  end

  protected 

  def set_department 
    @department = current_user.enterprise.departments.find(params[:id])
  end

  def department_params
    params
      .require(:department)
      .permit(
        :name
      )
  end
end

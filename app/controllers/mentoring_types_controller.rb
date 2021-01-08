class MentoringTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_type, only: [:show, :edit, :update, :destroy]

  layout 'mentorship'

  def index
    authorize MentoringType
    @types = current_user.enterprise.mentoring_types
  end

  def new
    authorize MentoringType
    @type = current_user.enterprise.mentoring_types.new
  end

  def create
    authorize MentoringType
    @type = current_user.enterprise.mentoring_types.new(type_params)

    if @type.save
      flash[:notice] = 'Your mentoring type was created'
      redirect_to action: :index
    else
      flash[:alert] = 'Your mentoring type was not created. Please fix the errors.'
      render :new
    end
  end

  def edit
    authorize MentoringType
  end

  def update
    authorize MentoringType

    if @type.update(type_params)
      flash[:notice] = 'The mentoring type was updated'
      redirect_to action: :index
    else
      flash[:alert] = 'The mentoring type was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize MentoringType

    @type.destroy
    redirect_to :back
  end

  private 

  def set_type
    @type = current_user.enterprise.mentoring_types.find(params[:id])
  end

  def type_params
    params
      .require(:mentoring_type)
      .permit(
          :name
      )
  end
end

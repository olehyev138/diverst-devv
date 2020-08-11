class IdeaCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_idea_category, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'collaborate'

  def index
    authorize IdeaCategory
    @idea_categories = policy_scope(IdeaCategory)
  end

  def new
    authorize IdeaCategory
    @idea_category = current_user.enterprise.idea_categories.new
  end

  def create
    authorize IdeaCategory
    @idea_category = current_user.enterprise.idea_categories.new(idea_params)

    if @idea_category.save 
      flash[:notice] = 'Your idea category was created'
      redirect_to action: :index
    else
      flash[:alert] = 'Your idea category was not created. Please fix the errors'
      render :new
    end
  end

  def edit
    authorize @idea_category
  end

  def update
    authorize @idea_category
    if @idea_category.update(idea_params)
      flash[:notice] = 'Your idea category was updated'
      redirect_to action: :index
    else
      flash[:alert] = 'Your idea category was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @idea_category
    @idea_category.destroy
    redirect_to action: :index
  end

  protected 

  def set_idea_category 
    @idea_category = current_user.enterprise.idea_categories.find(params[:id])
  end

  def idea_params
    params
      .require(:idea_category)
      .permit(
        :name
      )
  end
end

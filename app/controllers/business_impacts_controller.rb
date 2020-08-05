class BusinessImpactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_business_impact, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'collaborate'

  def index
    authorize BusinessImpact
    @business_impacts = policy_scope(BusinessImpact)
  end

  def new
    authorize BusinessImpact
    @business_impact = current_user.enterprise.business_impacts.new
  end

  def create
    authorize BusinessImpact
    @business_impact = current_user.enterprise.business_impacts.new(impact_params)

    if @business_impact.save 
      flash[:notice] = 'Your Business Impact was created'
      redirect_to action: :index
    else
      flash[:alert] = 'Your Business Impact was not created. Please fix the errors'
      render :new
    end
  end

  def edit
    authorize @business_impact
  end

  def update
    authorize @business_impact
    if @business_impact.update(impact_params)
      flash[:notice] = 'Your Business Impact was updated'
      redirect_to action: :index
    else
      flash[:alert] = 'Your Business Impact was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @business_impact
    @business_impact.destroy
    redirect_to action: :index
  end

  protected 

  def set_business_impact 
    @business_impact = current_user.enterprise.business_impacts.find(params[:id])
  end

  def impact_params
    params
      .require(:business_impact)
      .permit(
        :name
      )
  end
end

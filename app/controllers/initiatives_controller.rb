class InitiativesController < ApplicationController
  before_action :set_initiative, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'plan'

  def index
    authorize Initiative
    @initiatives = policy_scope(Initiative)
  end

  def new
    authorize Initiative
    @initiative = current_user.enterprise.initiatives.new
  end

  def create
    authorize Initiative
    @initiative = current_user.enterprise.initiatives.new(initiative_params)
    @initiative.owner = current_user

    if @initiative.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def show
    authorize @initiative
    @updates = @initiative.updates.order(created_at: :desc).limit(3).reverse # Shows the last 3 updates in chronological order
  end

  def edit
    authorize @initiative
  end

  def update
    authorize @initiative
    if @initiative.update(initiative_params)
      redirect_to @initiative
    else
      render :edit
    end
  end

  def destroy
    authorize @initiative
    @initiative.destroy
    redirect_to action: :index
  end

  protected

  def set_initiative
    @initiative = current_user.enterprise.initiatives.find(params[:id])
  end

  def initiative_params
    params
      .require(:initiative)
      .permit(
        :title,
        :start,
        :end,
        :estimated_funding,
        fields_attributes: [
          :id,
          :title,
          :_destroy,
          :gamification_value,
          :show_on_vcard,
          :saml_attribute,
          :type,
          :min,
          :max,
          :options_text,
          :alternative_layout
        ]
      )
  end
end

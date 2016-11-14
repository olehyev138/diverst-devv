class InitiativesController < ApplicationController
  before_action :set_group
  before_action :set_initiative, only: [:edit, :update, :destroy, :show, :todo]
  after_action :verify_authorized

  layout 'plan'

  def index
    authorize Initiative
    @outcomes = @group.outcomes.includes(pillars: { initiatives: :fields })
  end

  def new
    authorize Initiative
    @initiative = Initiative.new
  end

  def create
    authorize Initiative
    @initiative = Initiative.new(initiative_params)
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
      redirect_to [@group, :initiatives]
    else
      render :edit
    end
  end

  def destroy
    authorize @initiative
    @initiative.destroy
    redirect_to action: :index
  end

  def todo
    authorize @initiative, :update?
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_initiative
    @initiative = @group.initiatives.find(params[:id])
  end

  def initiative_params
    params
      .require(:initiative)
      .permit(
        :name,
        :description,
        :start,
        :end,
        :estimated_funding,
        :max_attendees,
        :pillar_id,
        :location,
        :picture,
        :associated_budget_id,
        participating_group_ids: [],
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
        ],
        checklist_items_attributes: [
          :id,
          :title,
          :is_done,
          :_destroy
        ]
      )
  end
end

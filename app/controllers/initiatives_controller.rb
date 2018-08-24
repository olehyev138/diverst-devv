class InitiativesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_initiative, only: [:edit, :update, :destroy, :show, :todo, :finish_expenses, :attendees]
  before_action :set_segments, only: [:new, :create, :edit, :update]
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
    @initiative.owner_group = @group
    #bTODO add event to @group.own_initiatives

    if @initiative.save
      flash[:notice] = "Your event was created"
      track_activity(@initiative, :create)
      redirect_to action: :index
    else
      flash[:alert] = "Your event was not created. Please fix the errors"
      render :new
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
    if @initiative.update(initiative_params.except!(:budget_item_id))
      flash[:notice] = "Your event was updated"
      track_activity(@initiative, :update)
      redirect_to [@group, :initiatives]
    else
      flash[:alert] = "Your event was not updated. Please fix the errors"
      render :edit
    end
  end

  def finish_expenses
    authorize @initiative, :update?

    # skip before_save :allocate_budget_funds because
    # finish_expenses primary responsibility is to close off
    # expenses and not to allocate_budget_funds
    @initiative.skip_allocate_budget_funds = true
    @initiative.finish_expenses!
    redirect_to action: :index
  end

  def destroy
    authorize @initiative

    track_activity(@initiative, :destroy)
    if @initiative.destroy
      flash[:notice] = "Your event was deleted"
      redirect_to action: :index
    else
      flash[:alert] = "Your event was not deleted. Please fix the errors"
      redirect_to :back
    end
  end

  def todo
    authorize @initiative, :update?
  end

  def attendees
    authorize @initiative, :update?

    send_data User.to_csv(users: @initiative.attendees, fields: current_user.enterprise.fields),
      filename: "attendees.csv"
  end

  protected

  def set_group
    current_user ? @group = current_user.enterprise.groups.find(params[:group_id]) : user_not_authorized
  end

  def set_initiative
    @initiative = @group.initiatives.find(params[:id])
  end

  def set_segments
    current_user ? @segments = current_user.enterprise.segments : user_not_authorized
  end

  def initiative_params
    params
      .require(:initiative)
      .permit(
        :name,
        :description,
        :start,
        :end,
        :max_attendees,
        :pillar_id,
        :location,
        :picture,
        :budget_item_id,
        :estimated_funding,
        participating_group_ids: [],
        segment_ids: [],
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

class GroupsController < ApplicationController
  before_action :authenticate_admin!, except: [:show, :join]
  before_action :authenticate_employee!, only: [:join]
  before_action :authenticate_user!, only: [:show]
  before_action :set_group, only: [:edit, :update, :destroy, :show]
  skip_before_action :verify_authenticity_token, only: [:create]

  layout :resolve_layout

  def index
    @groups = current_admin.enterprise.groups
  end

  def new
    @group = current_admin.enterprise.groups.new
  end

  def show
    @events = @group.events.limit(3)
    @news_links = @group.news_links.limit(3)
    @employee_groups = @group.employee_groups.order(created_at: :desc).limit(8)
    @messages = @group.messages.limit(3)
  end

  def create
    @group = current_admin.enterprise.groups.new(group_params)

    if @group.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def update
    if @group.update(group_params)
      redirect_to @group
    else
      render :edit
    end
  end

  def join
    @group.members << current_employee
    @group.save
  end

  def destroy
    @group.destroy
    redirect_to action: :index
  end

  protected

  def resolve_layout
    case action_name
    when "show"
      "erg"
    else
      "global_settings"
    end
  end

  def set_group
    @group = current_user.enterprise.groups.find(params[:id])
  end

  def group_params
    params
    .require(:group)
    .permit(
      :name,
      :description,
      :logo,
      :send_invitations,
      member_ids: [],
      invitation_segment_ids: []
    )
  end
end

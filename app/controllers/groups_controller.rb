class GroupsController < ApplicationController
  before_action :authenticate_admin!, except: [:join]
  before_action :authenticate_employee!, only: [:join]
  before_action :set_group, only: [:edit, :update, :destroy, :show]
  skip_before_action :verify_authenticity_token, only: [:create]

  layout :resolve_layout

  def index
    @groups = current_admin.enterprise.groups
  end

  def new
    @group = current_admin.enterprise.groups.new
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
    @group = current_admin.enterprise.groups.find(params[:id])
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

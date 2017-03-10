class Groups::LeadersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_leader, only: [:edit]
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize @group, :update?

    @group_leaders = @group.group_leaders
  end

  def new
    authorize @group, :update?

    @leader = GroupLeader.new
  end

  def edit
    authorize @group, :update?
  end

  def create
    authorize @group, :update?
    @leader = @group.group_leaders.new(group_leader_params)

    if @leader.save
      redirect_to action: :index
    else
      render :new
    end
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_leader
    @group_leader = @group.group_leaders.find(params[:id])
  end

  def group_leader_params
    params.require(:group_leader).permit(
      :user_id,
      :position_name
    )
  end
end

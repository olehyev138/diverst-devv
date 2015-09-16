class GroupsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_group, only: [:edit, :update, :destroy, :show]
  skip_before_action :verify_authenticity_token, only: [:create]

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

  def destroy
    @group.destroy
    redirect_to action: :index
  end

  protected

  def set_group
    @group = current_admin.enterprise.groups.find(params[:id])
  end

  def group_params
    params
    .require(:group)
    .permit(
      :name,
      rules_attributes: [
        :id,
        :_destroy,
        :field_id,
        :operator,
        values: []
      ]
    )
  end
end

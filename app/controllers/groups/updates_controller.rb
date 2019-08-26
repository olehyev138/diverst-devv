class Groups::UpdatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_update, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :show, :edit]

  layout 'erg'

  def index
    authorize @group, :update?
    @updates = @group.updates
  end

  def new
    authorize Group
    @update = @group.updates.new
  end

  def create
    authorize Group
    @update = @group.updates.new(update_params.merge({ owner_id: current_user.id }))
    @update.info.merge(fields: @group.fields, form_data: params['custom-fields'])

    if @update.save
      flash[:notice] = 'Your group update was created'
      track_activity(@update, :create)
      redirect_to action: :index
    else
      flash[:alert] = 'Your group update was not created. Please fix the errors'
      render :new
    end
  end

  def show
    authorize @group
  end

  def edit
    authorize Group
  end

  def update
    authorize Group
    @update.info.merge(fields: @group.fields, form_data: params['custom-fields'])

    if @update.update(update_params)
      flash[:notice] = 'Your group update was updated'
      track_activity(@update, :update)
      redirect_to action: :index
    else
      flash[:alert] = 'Your group update was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize Group
    track_activity(@update, :destroy)
    @update.destroy
    redirect_to action: :index
  end

  protected

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_update
    @update = @group.updates.find(params[:id])
  end

  def update_params
    params.require(:group_update).permit(:created_at)
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@group.to_label}'s Updates"
    when 'new'
      "#{@group.to_label}'s Update Creation"
    when 'show'
      "#{@group.to_label} Specific Update"
    when 'edit'
      "#{@group.to_label} Update Edit"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end

module IsResources
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_container
    before_action :set_resource, except: [:index, :new, :create, :archived, :restore_all, :delete_all]
    before_action :fetch_all_resources, only: [:restore, :restore_all, :destroy, :delete_all, :archived]
    before_action :set_container_path

    prepend_view_path 'app/views/shared/resources'
  end

  def index
    increment_views
    @resources = @container.resources.where(archived_at: nil).all # move .where query into Resource model as default scope
    render '/index'
  end

  def new
    @resource = @container.resources.new
    render '/new'
  end

  def edit
    render '/edit'
  end

  def create
    @resource = @container.resources.new(resource_params)

    if @resource.save
      track_activity(@resource, :create)
      @resource.tag_tokens = params[:resource][:tag_ids]
      redirect_to action: :index
    else
      render '/edit'
    end
  end

  def show
    if @resource.file.nil? || @resource.file.path.nil?
      flash[:alert] = 'File/File Path does not exist'
      redirect_to(request.referrer || default_path)
    else
      send_file @resource.file.path,
                filename: @resource.file_file_name,
                type: @resource.file_content_type,
                disposition: 'attachment'
    end
  end

  def update
    if @resource.update(resource_params)
      track_activity(@resource, :update)
      @resource.tag_tokens = params[:resource][:tag_ids]
      redirect_to action: :index
    else
      render '/edit'
    end
  end

  def destroy
    track_activity(@resource, :destroy)
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js
    end
  end

  def archive
    @resources = @container.resources.where(archived_at: nil).all
    @resource.update(archived_at: DateTime.now)
    track_activity(@resource, :archive)

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js
    end
  end

  def restore
    @resource.update(archived_at: nil)
    track_activity(@resource, :restore)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def archived
  end

  def restore_all
    @resources.update_all(archived_at: nil)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def delete_all
    @resources.destroy_all

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end


  protected

  def resource_params
    params
        .require(:resource)
        .permit(
          :title,
          :file,
          :resource_type,
          :folder_id,
          :url,
          :archived_at
        )
  end

  def set_resource
    @resource = @container.resources.find(params[:id]) if @container
  end

  def fetch_all_resources
    folder_ids = Folder.where(group_id: current_user.enterprise.group_ids).ids + current_user.enterprise.folder_ids
    initiative_ids = current_user.enterprise.initiative_ids
    @resources = Resource.unarchived_resources(folder_ids, initiative_ids)
  end

  def increment_views
    if @container.class.name === 'Folder'
      View.create!({
          folder_id: @container.id,
          user_id: current_user.id,
          enterprise_id: current_user.enterprise_id
      })
    end
  end
end

module IsResources
    extend ActiveSupport::Concern

    included do
        before_action :set_container
        before_action :set_resource, except: [:index, :new, :create]
        before_action :set_container_path

        prepend_view_path 'app/views/shared/resources'
    end

    def index
        increment_views
        @resources = @container.resources
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
            flash[:alert] = "File/File Path does not exist"
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
        redirect_to action: :index
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
                :url
            )
    end

    def set_resource
        @resource = @container.resources.find(params[:id]) if @container
    end

    def increment_views
        if @container.class.name === "Folder"
            view = View.find_or_create_by({
                :folder_id => @container.id,
                :user_id => current_user.id,
                :enterprise_id => current_user.enterprise_id
            })
            view.view_count += 1
            view.save!
        end
    end
end

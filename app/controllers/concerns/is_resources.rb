module IsResources
    extend ActiveSupport::Concern

    included do
        before_action :set_container
        before_action :set_resource, except: [:index, :new, :create]
        before_action :set_container_path

        prepend_view_path 'app/views/shared/resources'
    end

    def index
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
            @resource.tag_tokens = params[:resource][:tag_ids]
            redirect_to action: :index
        else
            render '/edit'
        end
    end

    def show
        send_file @resource.file.path,
                  filename: @resource.file_file_name,
                  type: @resource.file_content_type,
                  disposition: 'attachment'
    end

    def update
        if @resource.update(resource_params)
            @resource.tag_tokens = params[:resource][:tag_ids]
            redirect_to action: :index
        else
            render '/edit'
        end
    end

    def destroy
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
                :url
            )
    end

    def set_resource
        if @container
          @resource = @container.resources.find(params[:id])
        else
          flash[:alert] = "Container set to nil"
          redirect_to :back
        end
    end
end

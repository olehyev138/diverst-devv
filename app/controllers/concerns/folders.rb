module Folders
    extend ActiveSupport::Concern

    included do
        before_action :set_container
        before_action :set_folder, except: [:index, :new, :create]
        before_action :set_container_path

        prepend_view_path 'app/views/shared/folders'
    end

    def authenticate
        if @folder.valid_password?(params[:folder][:password])
            redirect_to [@container, @folder, :resources]
        else
            flash[:alert] = "Invalid Password"
            redirect_to :back
        end
    end

    def index
        authorize_action
        @folders = @container.folders.only_parents + @container.shared_folders.only_parents
        @folders.sort_by!{ |f| f.name.downcase }
        render '/index'
    end

    def show
        authorize_action
        render "/show"
    end

    def new
        authorize_action
        @folder = @container.folders.new
        @folder.parent_id = params[:folder_id] 
        @folder.password
        render '/new'
    end

    def edit
        authorize_action
        render '/edit'
    end

    def create
        authorize_action
        @folder = @container.folders.new(folder_params)
        if @folder.save
            if @folder.parent_id
                redirect_to [@folder.parent.container, @folder.parent, :resources]
            else
                redirect_to action: :index
            end
        else
            render '/edit'
        end
    end

    def update
        authorize_action
        if @folder.update(folder_params)
            redirect_to action: :index
        else
            render '/edit'
        end
    end

    def destroy
        authorize_action
        @folder.destroy
        redirect_to action: :index
    end

    protected

    def folder_params
        params
            .require(:folder)
            .permit(
                :name,
                :parent_id,
                :password_protected,
                :password,
                :group_ids => []
            )
    end

    def set_folder
        @folder = @container.folders.find_by_id(params[:id]) || @container.shared_folders.find_by_id(params[:id])
    end
    
    def authorize_action
    end
end

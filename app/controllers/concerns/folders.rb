module Folders
    extend ActiveSupport::Concern

    included do
        before_action :set_container
        before_action :set_folder, except: [:index, :new, :create]
        before_action :set_container_path

        prepend_view_path 'app/views/shared/folders'
    end

    def index
        @folders = @container.folders + @container.shared_folders
        @folders.sort_by!{ |f| f.name.downcase }
        render '/index'
    end

    def new
        @folder = @container.folders.new
        render '/new'
    end

    def edit
        render '/edit'
    end

    def create
        @folder = @container.folders.new(folder_params)
        if @folder.save
            redirect_to action: :index
        else
            render '/edit'
        end
    end

    def update
        if @folder.update(folder_params)
            redirect_to action: :index
        else
            render '/edit'
        end
    end

    def destroy
        @folder.destroy
        redirect_to action: :index
    end

    protected

    def folder_params
        params
            .require(:folder)
            .permit(
                :name,
                :group_ids => []
            )
    end

    def set_folder
        @folder = @container.folders.find_by_id(params[:id]) || @container.shared_folders.find_by_id(params[:id])
    end
end

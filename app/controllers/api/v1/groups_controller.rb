class Api::V1::GroupsController < Api::V1::ApiController
    
    def index
        render :json => Group.all
    end
    
    def show
        render :json => Group.last
    end
    
    def create
        render :status => 201, :json => Group.last
    end
    
    def update
        render :json => Group.last
    end
    
    def destroy
        head :no_content
    end
end
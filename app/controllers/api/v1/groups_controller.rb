class Api::V1::GroupsController < Api::V1::ApiController
    
    def index
        render :json => Group.all
    end
    
    def show
    end
    
    def create
    end
    
    def update
    end
    
    def destroy
    end
end
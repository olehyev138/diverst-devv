class Api::V1::UsersController < Api::V1::ApiController
    
    def index
        render :json => User.all
    end
    
    def show
        render :json => User.last
    end
    
    def create
        render :status => 201, :json => User.last
    end
    
    def update
        render :json => User.last
    end
    
    def destroy
        head :no_content
    end
end
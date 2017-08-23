class Api::V1::ApiController < ActionController::Base
    
    before_action :authenticate
    
    rescue_from ActionController::RoutingError do |e|
    end
    
    rescue_from ActionView::MissingTemplate do |e|
    end
    
    # check if the request has permission to access
    # the API
    
    # status messages
    # 200 - ok
    # 201 - Resource Created
    # 204 - No Content
    # 400 - Bad Request - ex. render :json => :bad_request
    # 401 - Unauthorized
    # 404 - Not Found
    # 422 - Unprocessable Entity
    # 500 - Internal Server Error
    
    def authenticate
        # we can authenticate in several ways
        # options can be API Key along with checking if
        # they are an enterprise
        
        # we can also implement API rate limits to limit
        # the number of calls an
    end
end
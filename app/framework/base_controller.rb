module BaseController

    def index
        begin
            render :json => klass.index(self.diverst_request, params.permit!)
        rescue => e
            raise BadRequestException.new(e.message)
        end
    end

    def create
        begin
            render :json => klass.build(self.diverst_request, params)
        rescue => e
            case e
            when UnprocessableException
                raise UnprocessableException.new(e.resource)
            else
                raise BadRequestException.new(e.message)
            end
        end
    end

    def show
        begin
            render :json => klass.show(self.diverst_request, params)
        rescue => e
            raise BadRequestException.new(e.message)
        end
    end

    def update
        begin
            render :json => klass.update(self.diverst_request, params)
        rescue => e
            case e
            when UnprocessableException
                raise UnprocessableException.new(e.resource)
            else
                raise BadRequestException.new(e.message)
            end
        end
    end

    def destroy
        begin
            klass.destroy(self.diverst_request, params[:id])
            head :no_content
        rescue => e
            raise BadRequestException.new(e.message)
        end
    end

    private

    # returns model name for controller
    # ex: partners_controller will return Partner
    # custom controllers will need to define klass
    # or override controller methods

    def klass
        controller_name.classify.constantize
    end

end

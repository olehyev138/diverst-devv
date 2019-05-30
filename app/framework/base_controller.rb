module BaseController
  def index
    render json: klass.index(self.diverst_request, params.permit!)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create
    render json: klass.build(self.diverst_request, params)
  rescue => e
    case e
    when UnprocessableException
      raise UnprocessableException.new(e.resource)
    else
      raise BadRequestException.new(e.message)
    end
  end

  def show
    render json: klass.show(self.diverst_request, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update
    render json: klass.update(self.diverst_request, params)
  rescue => e
    case e
    when UnprocessableException
      raise UnprocessableException.new(e.resource)
    else
      raise BadRequestException.new(e.message)
    end
  end

  def destroy
    klass.destroy(self.diverst_request, params[:id])
    head :no_content
  rescue => e
    raise BadRequestException.new(e.message)
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

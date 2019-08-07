module BaseController
  def index
    render status: 200, json: klass.index(self.diverst_request, params.permit!)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create
    params[klass.symbol] = payload
    render status: 201, json: klass.build(self.diverst_request, params)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def show
    render status: 200, json: klass.show(self.diverst_request, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update
    params[klass.symbol] = payload
    render status: 200, json: klass.update(self.diverst_request, params)
  rescue => e
    case e
    when InvalidInputException
      raise
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

  def payload
    params.require(klass.symbol).permit(
      klass.attribute_names - ["id", "created_at", "updated_at", "enterprise_id"]
    )
  end

  private

  # returns model name for controller
  # ex: users_controller will return User
  # custom controllers will need to define klass
  # or override controller methods

  def klass
    controller_name.classify.constantize
  end
end

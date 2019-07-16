module BaseController
  def index
    authorize klass, :index?

    render status: 200, json: klass.index(self.diverst_request, params.permit!)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create
    authorize klass, :create?

    render status: 201, json: klass.build(self.diverst_request, params)
  rescue => e
    case e
    when UnprocessableException
      raise UnprocessableException.new(e.resource)
    else
      raise BadRequestException.new(e.message)
    end
  end

  def show
    authorize klass, :show?

    render status: 200, json: klass.show(self.diverst_request, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update
    authorize klass, :update?

    render status: 200, json: klass.update(self.diverst_request, params)
  rescue => e
    case e
    when UnprocessableException
      raise UnprocessableException.new(e.resource)
    else
      raise BadRequestException.new(e.message)
    end
  end

  def destroy
    authorize klass, :destroy?

    klass.destroy(self.diverst_request, params[:id])
    head :no_content
  rescue => e
    raise BadRequestException.new(e.message)
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

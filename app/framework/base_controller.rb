module BaseController
  def index
    # Authorize with policy, only if policy exists
    # TODO: Don't only authorize if policy exists as every model should have a policy.
    # TODO: This is temporary to allow API calls to work properly without a policy during development.
    authorize klass, :index? if Pundit.policy(current_user, klass)

    render status: 200, json: klass.index(self.diverst_request, params.permit!)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create
    authorize klass, :create? if Pundit.policy(current_user, klass)

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
    authorize klass, :show? if Pundit.policy(current_user, klass.find(params[:id]))

    render status: 200, json: klass.show(self.diverst_request, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update
    authorize klass, :update? if Pundit.policy(current_user, klass.find(params[:id]))

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
    authorize klass, :destroy? if Pundit.policy(current_user, klass.find(params[:id]))

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

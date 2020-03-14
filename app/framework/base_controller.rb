module BaseController
  def index
    # Authorize with policy, only if policy exists
    # TODO: Don't only authorize if policy exists as every model should have a policy.
    # TODO: This is temporary to allow API calls to work properly without a policy during development.
    base_authorize(klass)

    render status: 200, json: klass.index(self.diverst_request, params.permit!)
  rescue => e
    case e
    when Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def export_csv
    base_authorize(klass)

    CsvDownloadJob.perform_later(current_user.id, params.permit!.to_json, klass_name: klass.name)
    head :no_content
  rescue => e
    case e
    when Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def create
    params[klass.symbol] = payload
    base_authorize(klass)

    render status: 201, json: klass.build(self.diverst_request, params)
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def show
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: klass.show(self.diverst_request, params)
  rescue => e
    case e
    when Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def update
    params[klass.symbol] = payload
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: klass.update(self.diverst_request, params)
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def destroy
    item = klass.find(params[:id])
    base_authorize(item)
    klass.destroy(self.diverst_request, params[:id])
    head :no_content
  rescue => e
    case e
    when Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def payload
    params.require(klass.symbol).permit(
      klass.attribute_names - ['id', 'created_at', 'updated_at', 'enterprise_id', 'owner_id']
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

  # Accepts a model instance or class
  # If there is a policy it checks authorization for the current action
  # If there is no policy it doesn't raise any errors - TODO: Done temporarily to allow models without policies to work during development
  def base_authorize(item)
    policy = Pundit::PolicyFinder.new(item).policy
    unless policy.nil? || (@policy ||= policy.new(current_user, item, params)).send(action_name + '?')
      raise Pundit::NotAuthorizedError, query: action_name, record: item, policy: policy
    end
  end
end

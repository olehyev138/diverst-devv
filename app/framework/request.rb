class Request
  attr_accessor :controller
  attr_accessor :action
  attr_accessor :user
  attr_accessor :policy_group

  def create_request(user)
    request = Request.new
    request.user = user
    request.policy_group = user.policy_group
    request
  end
end

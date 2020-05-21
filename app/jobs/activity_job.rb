class ActivityJob < ActiveJob::Base
  queue_as :default

  def perform(object_class, object_id, activity_name, user_id, params = {})
    model = object_class.constantize.find_by_id(object_id)
    return if model.nil?

    current_user = User.find_by_id(user_id)
    return if current_user.nil?

    model.create_activity activity_name,
                          owner: current_user,
                          recipient: current_user.enterprise,
                          params: params
  end
end

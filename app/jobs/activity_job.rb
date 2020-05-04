class ActivityJob < ActiveJob::Base
  queue_as :default

  def perform(object_class, object_id, activity_name, user_id, params = {})
    current_user = User.find_by_id(user_id)
    return if current_user.nil?

    model = object_class.constantize.find_by_id(object_id)
    if model
      model.create_activity activity_name,
                            owner: current_user,
                            recipient: current_user.enterprise,
                            params: params
    else
      Activity.create trackable_id: object_id,
                      trackable_type: object_class,
                      owner: current_user,
                      recipient: current_user.enterprise,
                      parameters: params,
                      key: "#{object_class.constantize.model_name.param_key}.#{activity_name}"
    end
  end
end

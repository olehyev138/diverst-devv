class SyncYammerGroupJob < ActiveJob::Base
  queue_as :default

  def perform(group)
    yammer = YammerClient.new(group.enterprise.yammer_token)

    # Subscribe employees who are part of the ERG in Diverst to the Yammer group
    group.members.each do |employee|
      yammer_user = yammer.user_with_email(employee.email)
      next if yammer_user.nil? # Skip employee if he/she isn't part of the Yammer network

      # Cache the employee's yammer token if it's not
      if employee.yammer_token.nil?
        yammer_user_token = yammer.token_for_user(user_id: yammer_user['id'])
        employee.update(yammer_token: yammer_user_token['token'])
      end

      # Impersonate the employee and subscribe to the group
      employee_yammer = YammerClient.new(employee.yammer_token)
      employee_yammer.subscribe_to_group(group.yammer_id)
    end
  end
end

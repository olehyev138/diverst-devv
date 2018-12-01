class SyncYammerGroupJob < ActiveJob::Base
  queue_as :default

  def perform(group_id)
    group = Group.find_by_id(group_id)
    return if group.nil?

    return if !group.enterprise.yammer_token

    yammer = YammerClient.new(group.enterprise.yammer_token)

    # Subscribe users who are part of the ERG in Diverst to the Yammer group
    group.members.each do |user|
      yammer_user = yammer.user_with_email(user.email)
      next if yammer_user.nil? # Skip user if he/she isn't part of the Yammer network

      # Cache the user's yammer token if it's not
      if user.yammer_token.nil?
        yammer_user_token = yammer.token_for_user(user_id: yammer_user['id'])
        user.update(yammer_token: yammer_user_token['token'])
      end

      # Impersonate the user and subscribe to the group
      user_yammer = YammerClient.new(user.yammer_token)
      user_yammer.subscribe_to_group(group.yammer_id)
    end
  end
end

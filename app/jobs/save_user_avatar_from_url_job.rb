class SaveUserAvatarFromUrlJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, url)
    user = User.find_by_id(user_id)
    return if user.nil?

    begin
      user.avatar = URI.parse(url)
    rescue Exception => e
      puts "#{ e.message }"
    end

    user.save
  end
end

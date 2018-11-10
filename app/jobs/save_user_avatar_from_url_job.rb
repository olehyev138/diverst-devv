class SaveUserAvatarFromUrlJob < ActiveJob::Base
  queue_as :default

  def perform(user, url)
    begin
      user.avatar = URI.parse(url)
    rescue Exception => e
      puts "#{ e.message }"
    end

    user.save
  end
end

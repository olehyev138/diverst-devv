class SaveUserAvatarFromUrlJob < ActiveJob::Base
  queue_as :default

  def perform(user, url)
    user.avatar = URI.parse(url)
    user.save
  end
end

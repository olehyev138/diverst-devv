class SaveUserAvatarFromUrlJob < ActiveJob::Base
  queue_as :default

  def perform(user, url)
    user.avatar = open(url)
    user.save
  end
end

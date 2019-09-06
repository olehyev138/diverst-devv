class UserWithMentorCount < ActiveRecord::Base
  self.primary_key = :user_id

  # def self.where(*args)
  #   p "UserWithMentorCount.where(#{args})"
  #   Rails.cache.fetch("UserWithMentorCount.where(#{args})", expires_in: 2.hour) do
  #     super(*args)
  #   end
  # end
end

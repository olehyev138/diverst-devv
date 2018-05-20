class Like < ActiveRecord::Base
  belongs_to :news_feed_link
  belongs_to :answer
  belongs_to :enterprise
  belongs_to :user

  validates :enterprise_id, presence: true
  validates :user_id, presence: true

  # Validate to make sure that a maximum of one like object exists for a post/answer, user, and enterprise
  # * Moved to DB constraint to prevent race condition *
end

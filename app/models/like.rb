class Like < ApplicationRecord
  belongs_to :enterprise
  belongs_to :user

  # Objects that can be liked
  belongs_to :news_feed_link, counter_cache: true
  belongs_to :answer, counter_cache: true

  validates :enterprise_id, presence: true
  validates :user_id, presence: true

  # Validate to make sure that a maximum of one like object exists for a post/answer, user, and enterprise
  # * Moved to DB constraint to prevent race condition *
end

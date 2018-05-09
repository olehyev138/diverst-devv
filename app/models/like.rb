class Like < ActiveRecord::Base
  belongs_to :news_feed_link
  belongs_to :enterprise
  belongs_to :user

  validates :news_feed_link_id,    presence: true
  validates :enterprise_id,        presence: true
  validates :user_id,              presence: true

  validates :news_feed_link_id, uniqueness: { scope: [:user_id, :enterprise_id] }
end

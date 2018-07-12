class ShareLink < ActiveRecord::Base
  belongs_to :news_feed
  belongs_to :news_feed_link

  has_one :group, through: :news_feed
end

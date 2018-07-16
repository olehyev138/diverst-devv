class NewsFeed < ActiveRecord::Base
  belongs_to :group

  has_many :share_links, dependent: :destroy
  has_many :news_feed_links, through: :share_links

  validates :group_id, presence: true
end

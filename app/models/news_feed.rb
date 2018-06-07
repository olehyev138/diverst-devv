class NewsFeed < ActiveRecord::Base
    belongs_to :group

    has_many :news_feed_links, dependent: :destroy

    validates :group_id, presence: true
end

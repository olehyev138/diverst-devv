class NewsFeedLink < ActiveRecord::Base
    belongs_to :news_feed
    belongs_to :group_message
    belongs_to :news_link
    belongs_to :social_link
    
    has_many :news_feed_link_segments

    delegate :group,    :to => :news_feed
    delegate :segment,  :to => :news_feed_link_segment, :allow_nil => true

    scope :approved,        -> { where(approved: true )}
    scope :not_approved,    -> { where(approved: false )}

    validates :news_feed_id,    presence: true

    after_create :approve_link

    # checks if link can automatically be approved
    # links are automatically approved if author is a
    # group leader
    def approve_link
        if GroupPolicy.new(link.author, link.group).erg_leader_permissions?
            self.approved = true
            self.save!
        end
    end
    
    def link
        return group_message if group_message
        return news_link if news_link
        return social_link if social_link
    end
end

class NewsFeedLink < ActiveRecord::Base
    belongs_to :news_feed
    belongs_to :link, :polymorphic => true

    has_many :news_feed_link_segments
    has_many :news_feed_likes, dependent: :destroy

    delegate :group,    :to => :news_feed
    delegate :segment,  :to => :news_feed_link_segment, :allow_nil => true

    scope :approved,        -> { where(approved: true )}
    scope :not_approved,    -> { where(approved: false )}

    validates :news_feed_id,    presence: true
    validates :link_id,         presence: true
    validates :link_type,       presence: true

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
end

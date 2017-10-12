class NewsFeedLink < ActiveRecord::Base
    belongs_to :news_feed
    belongs_to :link, :polymorphic => true
    
    has_one :news_feed_link_segment
    
    delegate :group, :to => :news_feed

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
            # send mailer if group message
            if link_type === "GroupMessage"
                link.send_emails
            end
            UserGroupNotificationJob.perform_later(link.group, news_count: 1)
        end
    end
end

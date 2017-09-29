class NewsFeedLink < ActiveRecord::Base
    belongs_to :news_feed
    belongs_to :link, :polymorphic => true
    
    scope :approved, -> { where(approved: true )}
    scope :not_approved, -> { where(approved: false )}
    
    validates :news_feed_id,    presence: true
    validates :link_id,         presence: true
    validates :link_type,       presence: true
end

class NewsFeedLink < ActiveRecord::Base
    belongs_to :news_feed
    belongs_to :link, :polymorphic => true

    has_many :news_feed_link_segments
    has_many :likes, dependent: :destroy
    has_many :views, dependent: :destroy

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

    # View Count methods
    def increment_view(user)
      view = views.find_or_create_by(user_id: user.id) do |v|
        v.enterprise_id = user.enterprise_id
      end

      view.view_count += 1
      view.save
    end

    def total_views
      views.sum(:view_count)
    end

    def unique_views
      views.all.count
    end
end

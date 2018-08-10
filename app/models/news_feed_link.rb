class NewsFeedLink < ActiveRecord::Base
    belongs_to :news_feed
    belongs_to :link, :polymorphic => true

    has_many :news_feed_link_segments, dependent: :destroy
    has_many :segments, through: :news_feed_link_segments
    has_many :shared_news_feed_links, :class_name => "SharedNewsFeedLink", source: :news_feed_link, dependent: :destroy
    has_many :shared_news_feeds, :through => :shared_news_feed_links, source: :news_feed
    
    has_many :likes, dependent: :destroy
    has_many :views, dependent: :destroy

    delegate :group,    :to => :news_feed
    delegate :segment,  :to => :news_feed_link_segment, :allow_nil => true

    scope :approved,        -> { where(approved: true )}
    scope :not_approved,    -> { where(approved: false )}
    scope :combined_news_links, -> (news_feed_id){joins("LEFT OUTER JOIN shared_news_feed_links ON shared_news_feed_links.news_feed_link_id = news_feed_links.id").where("shared_news_feed_links.news_feed_id = #{news_feed_id} OR news_feed_links.news_feed_id = #{news_feed_id} AND news_feed_links.approved = 1").distinct}
    
    validates :news_feed_id,    presence: true
    validates :link_id,         presence: true, :on => :update
    validates :link_type,       presence: true, :on => :update

    after_create :approve_link

    # checks if link can automatically be approved
    # links are automatically approved if author is a
    # group leader
    def approve_link
      return if link.nil?
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

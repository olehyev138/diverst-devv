class SocialLink < ActiveRecord::Base
    self.table_name = 'social_network_posts'

    has_many :social_link_segments, :dependent => :destroy
    has_many :segments, through: :social_link_segments, :before_remove => :remove_segment_association

    belongs_to :group
    belongs_to :author, class_name: 'User'

    has_one :news_feed_link, :as => :link, :dependent => :destroy
    accepts_nested_attributes_for :news_feed_link

    validates :author_id,       presence: true
    validate :correct_url?

    before_create :populate_embed_code, :add_trailing_slash

    scope :of_segments, ->(segment_ids) {
      gm_condtions = ["social_link_segments.segment_id IS NULL"]
      gm_condtions << "social_link_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
      joins("LEFT JOIN social_link_segments ON social_link_segments.social_link_id = social_network_posts.id")
      .where(gm_condtions.join(" OR "))
    }

    scope :unapproved, -> {joins(:news_feed_link).where(:news_feed_links => {:approved => false})}
    scope :approved, -> {joins(:news_feed_link).where(:news_feed_links => {:approved => true})}

    def url_safe
        CGI.escape(url)
    end

    # call back to delete news link segment associations
    def remove_segment_association(segment)
        social_link_segment = self.social_link_segments.where(:segment_id => segment.id).first
        social_link_segment.news_feed_link_segment.destroy
    end

    def unlink(group)
      news_feed_link.share_link(group).destroy
      self.destroy if news_feed_link.share_links.empty?
    end

    protected
      def correct_url?
          unless SocialMedia::Importer.valid_url? url
              errors.add(:url, "is not a valid url for supported services")
          end
      end

      def add_trailing_slash
          self.url = File.join(self.url, "")
      end

      def populate_embed_code
          self.embed_code = SocialMedia::Importer.url_to_embed url
      end
end

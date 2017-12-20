class SocialLink < ActiveRecord::Base
    self.table_name = 'social_network_posts'

    has_one :news_feed_link, :as => :link, :dependent => :destroy

    has_many :social_link_segments
    has_many :segments, through: :social_link_segments, :before_remove => :remove_segment_association

    validate :correct_url?

    validates :author_id,       presence: true

    before_create :populate_embed_code, :build_default_link, :add_trailing_slash

    belongs_to :author, class_name: 'User', required: true
    belongs_to :group

    scope :of_segments, ->(segment_ids) {
      gm_condtions = ["social_link_segments.segment_id IS NULL"]
      gm_condtions << "social_link_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
      joins("LEFT JOIN social_link_segments ON social_link_segments.social_link_id = social_network_posts.id")
      .where(gm_condtions.join(" OR "))
    }

    def url_safe
        CGI.escape(url)
    end

    # call back to delete news link segment associations
    def remove_segment_association(segment)
        social_link_segment = self.social_link_segments.where(:segment_id => segment.id).first
        social_link_segment.news_feed_link_segment.destroy
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

    private

    def build_default_link
        return if group_id.nil?
        build_news_feed_link(:news_feed_id => group.news_feed.id)
        true
    end
end

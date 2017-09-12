class SocialLink < ActiveRecord::Base
    self.table_name = 'social_network_posts'

    has_one :news_feed_link, :as => :link, :dependent => :destroy
    
    has_many :social_link_segments
    has_many :segments, through: :social_link_segments
    
    validate :correct_url?
    
    validates :author_id,       presence: true

    before_create :populate_embed_code, :build_default_link
    
    belongs_to :author, class_name: 'User', required: true
    belongs_to :group

    protected

    def correct_url?
        unless SocialMedia::Importer.valid_url? url
            errors.add(:url, "is not a valid url for supported services")
        end
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

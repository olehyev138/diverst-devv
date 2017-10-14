class NewsLink < ActiveRecord::Base
    belongs_to :group
    belongs_to :author, class_name: 'User'

    has_one :news_feed_link, :as => :link, :dependent => :destroy
    
    has_many :news_link_segments, :dependent => :destroy
    has_many :segments, through: :news_link_segments, :before_remove => :remove_segment_association
    
    before_validation :smart_add_url_protocol

    validates :url, presence: true

    has_many :comments, class_name: 'NewsLinkComment'

    validates :group_id,        presence: true
    validates :title,           presence: true
    validates :description,     presence: true
    validates :author_id,       presence: true

    has_attached_file :picture, styles: { medium: '1000x300>', thumb: '100x100>' }, s3_permissions: :private
    validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}
    
    before_create :build_default_link

    scope :of_segments, ->(segment_ids) {
      nl_condtions = ["news_link_segments.segment_id IS NULL"]
      nl_condtions << "news_link_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
      joins("LEFT JOIN news_link_segments ON news_link_segments.news_link_id = news_links.id")
      .where(nl_condtions.join(" OR "))
    }

    # call back to delete news link segment associations
    def remove_segment_association(segment)
        news_link_segment = self.news_link_segments.where(:segment_id => segment.id).first
        news_link_segment.news_feed_link_segment.destroy
    end
    
    protected

    def smart_add_url_protocol
        return nil if url.blank?
        self.url = "http://#{url}" unless have_protocol?
    end

    def have_protocol?
        url[%r{\Ahttp:\/\/}] || url[%r{\Ahttps:\/\/}]
    end
    
    private
    
    def build_default_link
        build_news_feed_link(:news_feed_id => group.news_feed.id)
        true
    end
end

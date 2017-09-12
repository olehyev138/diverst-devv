class NewsLink < ActiveRecord::Base
    belongs_to :group
    belongs_to :author, class_name: 'User'

    has_one :news_feed_link, :as => :link, :dependent => :destroy
    
    has_many :news_link_segments
    has_many :segments, through: :news_link_segments
    
    before_validation :smart_add_url_protocol

    has_many :comments, class_name: 'NewsLinkComment'

    validates :group_id,        presence: true
    validates :title,           presence: true
    validates :description,     presence: true
    validates :author_id,       presence: true

    has_attached_file :picture, styles: { medium: '1000x300>', thumb: '100x100>' }, s3_permissions: :private
    validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}
    
    before_create :build_default_link
    
    protected

    def smart_add_url_protocol
        self.url = "http://#{url}" unless url[%r{\Ahttp:\/\/}] || url[%r{\Ahttps:\/\/}]
    end
    
    private
    
    def build_default_link
        build_news_feed_link(:news_feed_id => group.news_feed.id)
        true
    end
end

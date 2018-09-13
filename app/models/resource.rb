class Resource < ActiveRecord::Base
    EXPIRATION_TIME = 6.months.to_i

    belongs_to :container, polymorphic: true
    belongs_to :owner, class_name: "User"
    belongs_to :mentoring_session
    
    has_many :tags, :as => :taggable, :dependent => :destroy
    has_many :views, dependent: :destroy
    
    accepts_nested_attributes_for :tags

    has_attached_file :file, s3_permissions: "private"
    validates_with AttachmentPresenceValidator, attributes: :file, :if => Proc.new { |r| r.url.blank? }
    do_not_validate_attachment_file_type :file

    validates_presence_of :title
    validates_presence_of :url, :if => Proc.new { |r| r.file.nil? && r.url.blank? }

    before_validation :smart_add_url_protocol

    attr_reader :tag_tokens

    def tag_tokens=(tokens)
        return if tokens.nil?
        return if tokens === ""

        self.tag_ids = Tag.ids_from_tokens(tokens)
    end

    def file_extension
        File.extname(file_file_name)[1..-1].downcase
    rescue
        ''
    end

    def expiration_time
        EXPIRATION_TIME
    end
    
    def total_views
        views.sum(:view_count)
    end


    protected

    def smart_add_url_protocol
        return nil if url.blank?
        self.url = "http://#{url}" unless have_protocol?
    end

    def have_protocol?
        url[%r{\Ahttp:\/\/}] || url[%r{\Ahttps:\/\/}]
    end
end

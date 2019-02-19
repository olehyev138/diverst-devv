class Resource < BaseClass
    include PublicActivity::Common

    EXPIRATION_TIME = 6.months.to_i

    # associations
    belongs_to :enterprise
    belongs_to :folder
    belongs_to :initiative
    belongs_to :group
    belongs_to :owner, class_name: "User"
    belongs_to :mentoring_session

    has_many :tags, dependent: :destroy
    has_many :views, dependent: :destroy

    accepts_nested_attributes_for :tags

    has_attached_file :file, s3_permissions: "private"
    validates_with AttachmentPresenceValidator, attributes: :file, :if => Proc.new { |r| r.url.blank? }
    do_not_validate_attachment_file_type :file

    validates_presence_of   :title
    validates_presence_of   :url, :if => Proc.new { |r| r.file.nil? && r.url.blank? }
    validates_length_of     :url, maximum: 255

    before_validation :smart_add_url_protocol
    after_commit :archive_expired_resources, on: [:create, :update, :destroy]

    attr_reader :tag_tokens

    settings do
      mappings dynamic: false do
        indexes :owner_id, type: :integer
        indexes :created_at, type: :date
        indexes :folder do
          indexes :group_id, type: :integer
          indexes :group do
            indexes :enterprise_id, type: :integer
          end
        end
      end
    end

    def as_indexed_json(options = {})
      self.as_json(
        options.merge(
          only: [:owner_id, :created_at],
          include: { folder: {
            only: [:id, :group_id],
            include: { group: { only: [:enterprise_id]  } }
          }}
        )
      )
    end

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

    def container
        return enterprise if enterprise.present?
        return folder if folder.present?
        return initiative if initiative.present?
        return group if group.present?
        return mentoring_session if mentoring_session.present?
    end

    def total_views
        views.count
    end

    protected

    def archive_expired_resources
        expiry_date = DateTime.now.months_ago(6)
        resources = Resource.where("created_at < ?", expiry_date)
        resources.update_all(archived_at: DateTime.now) if resources.any?
    end

    def smart_add_url_protocol
        return nil if url.blank?
        self.url = "http://#{url}" unless have_protocol?
    end

    def have_protocol?
        url[%r{\Ahttp:\/\/}] || url[%r{\Ahttps:\/\/}]
    end
end

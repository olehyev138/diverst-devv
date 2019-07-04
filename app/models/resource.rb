class Resource < BaseClass
  include PublicActivity::Common

  EXPIRATION_TIME = 6.months.to_i

  # associations
  belongs_to :enterprise
  belongs_to :folder
  belongs_to :initiative
  belongs_to :group
  belongs_to :owner, class_name: 'User'
  belongs_to :mentoring_session

  has_many :tags, dependent: :destroy
  has_many :views, dependent: :destroy

  accepts_nested_attributes_for :tags

  has_attached_file :file, s3_permissions: 'private'
  validates_length_of :resource_type, maximum: 191
  validates_length_of :file_content_type, maximum: 191
  validates_length_of :file_file_name, maximum: 191
  validates_length_of :title, maximum: 191
  validates_with AttachmentPresenceValidator, attributes: :file, if: Proc.new { |r| r.url.blank? }
  do_not_validate_attachment_file_type :file

  validates_presence_of   :title
  validates_presence_of   :url, if: Proc.new { |r| r.file.nil? && r.url.blank? }
  validates_length_of     :url, maximum: 255

  scope :unarchived_resources, ->(folder_ids, initiative_ids) { where('resources.initiative_id IN (?) OR resources.folder_id IN (?)', initiative_ids, folder_ids).where.not(archived_at: nil) }

  before_validation :smart_add_url_protocol

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
          include: { group: { only: [:enterprise_id] } }
        } }
      )
    ).merge({ 'created_at' => self.created_at.beginning_of_hour })
  end

  def tag_tokens=(tokens)
    return if tokens.nil?
    return if tokens === ''

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
    views.size
  end

  def self.archive_expired_resources(group)
    enterprise = group.enterprise
    return unless group.auto_archive? || enterprise.auto_archive?

    if group.auto_archive?
      expiry_date = DateTime.now.send("#{group.unit_of_expiry_age}_ago", group.expiry_age_for_resources)
      group_resources = Resource.joins(:folder).where.not(folders: { group_id: nil }).where(folders: { enterprise_id: nil }).where('resources.created_at < ?', expiry_date).where(archived_at: nil)

      group_resources.update_all(archived_at: DateTime.now) if group_resources.any?
    end

    if enterprise.auto_archive?
      expiry_date = DateTime.now.send("#{enterprise.unit_of_expiry_age}_ago", enterprise.expiry_age_for_resources)
      enterprise_resources = Resource.joins(:folder).where(folders: { group_id: nil }).where.not(folders: { enterprise_id: nil }).where('resources.created_at < ?', expiry_date).where(archived_at: nil)

      enterprise_resources.update_all(archived_at: DateTime.now) if enterprise_resources.any?
    end
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

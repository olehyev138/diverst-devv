class Resource < ApplicationRecord
  include PublicActivity::Common
  include Resource::Actions

  EXPIRATION_TIME = 6.months.to_i

  # associations
  belongs_to :folder
  belongs_to :enterprise
  belongs_to :initiative
  belongs_to :group
  belongs_to :owner, class_name: 'User'
  belongs_to :mentoring_session

  has_many :tags, dependent: :destroy
  has_many :views, dependent: :destroy

  accepts_nested_attributes_for :tags

  # ActiveStorage
  has_one_attached :file
  validates :file, attached: true, if: Proc.new { |r| r.url.blank? }

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :file_paperclip, s3_permissions: 'private'

  validates_length_of :resource_type, maximum: 191
  validates_length_of :title, maximum: 191
  validates_presence_of   :title
  validates_presence_of   :url, if: Proc.new { |r| !r.file.attached? }
  validates_length_of     :url, maximum: 255

  scope :unarchived_resources, ->(folder_ids, initiative_ids) { where('resources.initiative_id IN (?) OR resources.folder_id IN (?)', initiative_ids, folder_ids).where.not(archived_at: nil) }
  scope :not_archived, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  before_validation :smart_add_url_protocol

  before_save :unset_enterprise

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

  # TEMP: Need to create InitiativeResourcePolicy, and MentorSessionResourcePolicy
  def policy_class
    if group_id || initiative_id
      GroupResourcePolicy
    elsif enterprise_id || mentoring_session_id
      EnterpriseResourcePolicy
    else
      case folder.policy_class.name
      when 'GroupFolderPolicy' then GroupResourcePolicy
      when 'EnterpriseFolderPolicy' then EnterpriseResourcePolicy
      else raise StandardError.new('Folder is without parent')
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

  def file_location
    return nil unless file.attached?

    Rails.application.routes.url_helpers.url_for(file)
  end

  def path_for_file_download
    return nil unless self.file.attached?

    Rails.application.routes.url_helpers.rails_blob_path(self.file, only_path: true, disposition: 'attachment')
  end

  def expiration_time
    EXPIRATION_TIME
  end

  def container
    return enterprise if enterprise.present?
    return folder if folder.present?
    return initiative if initiative.present?
    return group if group.present?

    mentoring_session.presence
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

  # TODO: Find a better solution to not set enterprise for resource objects
  def unset_enterprise
    self.enterprise_id = nil if self.group_id.present?
  end
end

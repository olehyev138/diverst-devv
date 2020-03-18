class Folder < ApplicationRecord
  include PublicActivity::Common
  include Folder::Actions

  has_secure_password(validations: false)

  # associations
  belongs_to  :enterprise
  belongs_to  :group
  belongs_to  :parent, class_name: 'Folder', foreign_key: :parent_id

  has_many    :views, dependent: :destroy
  has_many    :resources, dependent: :destroy
  has_many    :folder_shares, dependent: :destroy
  has_many    :groups, through: :folder_shares, source: 'group'
  has_many    :children, class_name: 'Folder', foreign_key: :parent_id, dependent: :destroy

  # validations
  validates_length_of :password_digest, maximum: 191
  validates_length_of :name, maximum: 191
  validates :name, presence: true
  validates_uniqueness_of :name, scope: [:enterprise_id], if: -> { enterprise_id.present? }
  validates_uniqueness_of :name, scope: [:group_id], if: -> { group_id.present? }
  validates :password, presence: true, if: Proc.new { |folder| folder.password_protected? && !folder.password_digest }
  validates :password, length: { minimum: 6 }, if: Proc.new { |folder| folder.password_protected? && folder.password.present? }
  validate :parent_is_not_self, if: Proc.new { |folder| folder.id.present? && folder.parent_id.present? }

  # scopes
  scope :only_parents, -> { where(parent_id: nil) }

  # callbacks
  before_save :set_password
  before_save :unset_enterprise

  def policy_class
    if group_id
      GroupFolderPolicy
    elsif enterprise_id
      EnterpriseFolderPolicy
    else
      raise StandardError.new('Folder is without parent')
    end
  end

  def set_password
    self.password = nil unless password_protected?
  end

  def valid_password?(user_password)
    authenticate(user_password)
  end

  def total_views
    views.size
  end

  private

  def parent_is_not_self
    if id == parent_id
      errors.add(:parent, 'can\'t be itself')
    end
  end

  # TODO: Find a better solution to not set enterprise for folder objects
  def unset_enterprise
    self.enterprise_id = nil if self.group_id.present?
  end
end

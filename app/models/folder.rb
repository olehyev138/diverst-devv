class Folder < ActiveRecord::Base

  has_secure_password(validations: false)

  # associations
  belongs_to  :container, polymorphic: true
  has_many    :resources, as: :container
  has_many    :folder_shares
  has_many    :groups, through: :folder_shares, source: "container", source_type: 'Group'

  has_many    :children, class_name: "Folder", foreign_key: :parent_id
  belongs_to  :parent,   class_name: "Folder", foreign_key: :parent_id

  # validations
  validates :name, presence: true
  validates :container, presence: true
  validates :container, presence: true
  validates_uniqueness_of :name, scope: [:container]
  validates :password, :presence => true, :if => Proc.new { |folder| folder.password_protected? and !folder.password_digest}
  validates :password, :length => { :minimum => 6 }, :if => Proc.new { |folder| folder.password_protected? and folder.password.present?}
  
  # scopes
  scope :only_parents, -> {where(:parent_id => nil)}
  
  # callbacks
  before_save :set_password

  def set_password
    self.password = nil if !password_protected?
  end

  def valid_password?(user_password)
    return authenticate(user_password)
  end

end

# each user role has it's own policy_group_template
# any time a user is created, the user will have a specfic role and the
# policy_group_template for that role will be used to create the policy_group
# for that user

class UserRole < BaseClass
  include PublicActivity::Common

  # associations
  belongs_to  :enterprise, inverse_of: :user_roles
  has_one     :policy_group_template, inverse_of: :user_role, dependent: :delete

  # validations
  validates_length_of :role_type, maximum: 191
  validates_length_of :role_name, maximum: 191
  validates :role_name,               presence: true, length: { minimum: 3 }
  validates :role_type,               presence: true
  validates :enterprise,              presence: true
  validates :priority,                presence: true
  validates :policy_group_template,   presence: true, on: :update

  validates_uniqueness_of :role_name,             scope: [:enterprise]
  validates_uniqueness_of :priority,              scope: [:enterprise]
  # validates_uniqueness_of :policy_group_template, scope: [:enterprise], :on => :update
  validates_uniqueness_of :default,               scope: [:enterprise], conditions: -> { where(default: true) }

  before_destroy  :can_destroy?, prepend: true

  after_destroy   :reset_user_roles

  # scopes
  scope :user_type,   ->  { where(role_type: 'user') }
  scope :group_type,  ->  { where(role_type: 'group') }
  scope :priorities,  ->  { pluck(:priority) }
  scope :default,     ->  { find_by(default: true) }

  # before the user role is created we need to create a template that
  # is tied to this role

  before_create :build_default_policy_group_template

  def build_default_policy_group_template
    build_policy_group_template(name: "#{role_name} Policy Template", enterprise: enterprise, default: default)
    true
  end

  def self.role_types
    ['admin', 'user', 'group']
  end

  # this assumes that an enterprise won't have more than 20 roles
  def self.available_priorities(existing = [])
    (1..20).to_a - existing
  end

  # we don't want to delete any group roles or the default role
  def can_destroy?
    if default
      errors[:base] << 'Cannot destroy default user role'
      return false
    elsif role_type === 'group'
      if GroupLeader.joins(group: :enterprise).where(groups: { enterprise_id: enterprise.id }, user_role_id: id).count > 0
        errors[:base] << 'Cannot delete because there are users with this group role.'
        return false
      end
    end
    true
  end

  def reset_user_roles
    ResetUserRoleJob.perform_later(id, enterprise_id)
  end
end

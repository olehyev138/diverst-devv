# each user role has it's own policy_group_template
# any time a user is created, the user will have a specfic role and the
# policy_group_template for that role will be used to create the policy_group
# for that user

class UserRole < ApplicationRecord
  include PublicActivity::Common

  # associations
  belongs_to  :enterprise, inverse_of: :user_roles
  has_one     :policy_group_template, inverse_of: :user_role, dependent: :destroy
  has_many    :group_leaders, inverse_of: :user_role
  has_many    :users, inverse_of: :user_role, dependent: :nullify

  # validations
  validates_length_of :role_type, maximum: 191
  validates_length_of :role_name, maximum: 191
  validates :role_name,               presence: true, length: { minimum: 3 }
  validates :role_type,               presence: true
  validates :enterprise,              presence: true
  validates :priority,                presence: true
  validates :policy_group_template,   presence: true, on: :update

  validates_uniqueness_of :role_name,             scope: [:enterprise_id]
  validates_uniqueness_of :priority,              scope: [:enterprise_id]
  validates_uniqueness_of :default,               scope: [:enterprise_id], conditions: -> { where(default: true) }

  before_destroy -> { throw :abort unless can_destroy? }, prepend: true
  before_update -> {
    if role_type_changed?
      errors.add(:role_type, I18n.t('errors.user_role.no_change'))
      throw :abort
    end
  }

  after_destroy :reset_user_roles

  # scopes
  scope :user_type,   ->  { where(role_type: 'user') }
  scope :group_type,  ->  { where(role_type: 'group') }
  scope :priorities,  ->  { pluck(:priority) }
  scope :default,     ->  { find_by(default: true) }

  # before the user role is created we need to create a template that
  # is tied to this role

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
      errors.add(:base, I18n.t('errors.user_role.delete_default'))
      return false
    elsif role_type === 'group'
      if group_leaders.size > 0
        errors.add(:base, I18n.t('errors.user_role.delete_group'))
        return false
      end
    end
    true
  end

  def reset_user_roles
    ResetUserRoleJob.perform_later(id, enterprise_id)
  end
end

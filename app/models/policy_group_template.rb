class PolicyGroupTemplate < BaseClass
  include PublicActivity::Common

  # associations
  belongs_to :user_role, inverse_of: :policy_group_template, dependent: :destroy
  belongs_to :enterprise

  # validations
  validates_length_of :name, maximum: 191
  validates :name,        presence: true
  validates :user_role,   presence: true
  validates :enterprise,  presence: true

  validates_uniqueness_of :name,          scope: [:enterprise_id]
  validates_uniqueness_of :user_role,     scope: [:enterprise_id]
  validates_uniqueness_of :default,       scope: [:enterprise_id], conditions: -> { where(default: true) }

  # retrieves fields for policy and returns them
  # to user object to create policy_group

  def create_new_policy
    attributes.except('id', 'name', 'enterprise_id', 'role', 'default', 'created_at', 'updated_at', 'user_role_id')
  end

  after_update :update_user_roles

  # finds users/group_leaders in the enterprise
  def update_user_roles
    PolicyGroupTemplateUpdateJob.perform_later(id)
  end
end

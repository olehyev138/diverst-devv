class PolicyGroupTemplate < ApplicationRecord
  include PublicActivity::Common
  INFINITE_FALSE = Enumerator.new do |yielder|
    loop do
      yielder.yield false
    end
  end

  POLICIES = attribute_names - ['id', 'name', 'deprecated_enterprise_id', 'role', 'default', 'created_at', 'updated_at', 'user_role_id']
  GROUP_LEADER_POLICIES = POLICIES & GroupLeader.attribute_names
  EMPTY_POLICY_ATTRIBUTES = (POLICIES.zip(INFINITE_FALSE)).to_h
  EMPTY_GROUP_LEADER_ATTRIBUTES = (GROUP_LEADER_POLICIES.zip(INFINITE_FALSE)).to_h

  # associations
  belongs_to :user_role, inverse_of: :policy_group_template
  has_one :enterprise, through: :user_role

  # validations
  validates_length_of :name, maximum: 191
  validates :name,        presence: true
  validates :user_role,   presence: true
  validates :enterprise,  presence: true

  validates_uniqueness_of :user_role_id
  validate :check_uniqueness_of_name
  delegate :enterprise_id, :enterprise_id=, :default, :default=, to: :user_role

  # retrieves fields for policy and returns them
  # to user object to create policy_group

  def create_new_policy
    attributes.slice(*POLICIES)
  end

  def create_new_group_leader
    attributes.slice(*GROUP_LEADER_POLICIES)
  end

  after_update :update_user_roles

  # finds users/group_leaders in the enterprise
  def update_user_roles
    if Rails.env.test?
      PolicyGroupTemplateUpdateJob.perform_now(id)
    else
      PolicyGroupTemplateUpdateJob.perform_later(id)
    end
  end

  private

  def check_uniqueness_of_name
    if enterprise && enterprise.policy_group_templates.where.not(id: self.id).where(name: self.name).exists?
      errors.add(:name, 'name already taken')
    end
  end
end

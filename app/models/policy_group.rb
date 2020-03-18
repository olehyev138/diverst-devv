class PolicyGroup < ApplicationRecord
  # associations
  belongs_to :user, inverse_of: :policy_group

  validates_uniqueness_of :user_id

  def self.users_that_able_to_accept_budgets(enterprise)
    enterprise.users.select { |u| u.policy_group.budget_approval }
  end

  def update_all_permissions(boolean = false)
    self.class.all_permission_fields.each do |permission|
      self[permission] = boolean
    end
    self.save!
  end

  def self.all_permission_fields
    PolicyGroup.columns_hash.select { |k, v| v.type.to_s === 'boolean' }.map { |field| field.first }
  end
end

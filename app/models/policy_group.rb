class PolicyGroup < ApplicationRecord
  # associations
  belongs_to :user, inverse_of: :policy_group

  validates_uniqueness_of :user

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

  def random_assignment
    attr = PolicyGroup.attribute_names - %w(manage_all created_at updated_at user_id id)
    PolicyGroup.where('user_id > 1').find_each do |pg|
      attr.each do |att|
        if att.include? 'index'
          pg.update_column att, rand(12) < 6
        elsif att.include? 'create'
          pg.update_column att, rand(12) < 4
        else
          pg.update_column att, rand(12) < 2
        end
      end
    end
  end
end

class RemovePolicyTemplateFromUserRoleCreation < ActiveRecord::Migration[5.2]
  def change
    PolicyGroupTemplate.find_each do |policy|
      policy.name = UserRole.find(policy.id).role_name
      policy.save!
    end
  end
end

require 'rails_helper'

RSpec.describe PolicyGroupTemplate, type: :model do
    describe 'test associations' do
        let(:user_role) { create(:user_role) }
        let(:policy_group_template) { user_role.policy_group_template }
        it{ expect(policy_group_template).to belong_to(:user_role)}
    end
    
    describe '#update_user_roles' do
        it "updates user policy_group with latest permissions" do
            admin = create(:user)
            expect(admin.policy_group.users_manage).to eq(true)
            
            policy_group_template = admin.enterprise.user_roles.where(:role_name => admin.role).first.policy_group_template
            policy_group_template.users_manage = false
            policy_group_template.save!
            
            # ensure the policy_group was updated
            admin.reload
            expect(admin.policy_group.users_manage).to eq(false)
        end
    end
end

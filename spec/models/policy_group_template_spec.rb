require 'rails_helper'

RSpec.describe PolicyGroupTemplate, type: :model do
    include ActiveJob::TestHelper
    
    describe 'test associations' do
        let(:user_role) { create(:user_role) }
        let(:policy_group_template) { user_role.policy_group_template }
        it{ expect(policy_group_template).to belong_to(:user_role)}
    end
    
    describe '#update_user_roles' do
        it "updates user policy_group with latest permissions" do
            allow(PolicyGroupTemplateUpdate).to receive(:perform_now).and_call_original
            admin = create(:user)
            expect(admin.policy_group.users_manage).to eq(true)
            
            policy_group_template = admin.enterprise.user_roles.where(:role_name => admin.role).first.policy_group_template
            policy_group_template.users_manage = false
            
            perform_enqueued_jobs do
                policy_group_template.save!
            end
        
            # ensure the job was called
            expect(PolicyGroupTemplateUpdate).to have_received(:perform_now)
            
            # ensure the policy_group was updated
            admin.reload
            expect(admin.policy_group.users_manage).to eq(false)
        end
        
        it "updates group leader with latest permissions" do
            allow(PolicyGroupTemplateUpdate).to receive(:perform_now).and_call_original
            group_leader = create(:group_leader)

            expect(group_leader.initiatives_manage).to eq(false)

            policy_group_template = group_leader.group.enterprise.user_roles.where(:role_name => group_leader.role).first.policy_group_template
            policy_group_template.initiatives_manage = true
            
            perform_enqueued_jobs do
                policy_group_template.save!
            end
        
            # ensure the job was called
            expect(PolicyGroupTemplateUpdate).to have_received(:perform_now)
            
            # ensure the group_leader was updated
            group_leader.reload
            expect(group_leader.groups_budgets_index).to eq(false)
        end
    end
end

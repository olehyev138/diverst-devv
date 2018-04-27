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
            allow(PolicyGroupTemplateUpdateJob).to receive(:perform_now).and_call_original
            enterprise = create(:enterprise)
            admin = create(:user, :enterprise => enterprise, :user_role => enterprise.user_roles.where(:role_type => "admin").first)
            expect(admin.policy_group.users_manage).to eq(true)
            
            policy_group_template = admin.enterprise.user_roles.where(:id => admin.user_role_id).first.policy_group_template
            policy_group_template.users_manage = false
            
            perform_enqueued_jobs do
                policy_group_template.save!
            end
            
            policy_group = admin.policy_group
            policy_group.reload
            policy_group_template.reload
            
            # ensure the job was called
            expect(PolicyGroupTemplateUpdateJob).to have_received(:perform_now)
            
            # ensure the policy_group was updated
            expect(admin.policy_group.users_manage).to eq(false)
        end
        
        it "updates group leader with latest permissions" do
            allow(PolicyGroupTemplateUpdateJob).to receive(:perform_now).and_call_original
            enterprise = create(:enterprise)
            group = create(:group, :enterprise => enterprise)
            user = create(:user, :enterprise => enterprise)
            group_leader = create(:group_leader, :group => group, :user => user, :user_role => enterprise.user_roles.where(:role_name => "group_leader").first)

            expect(group_leader.initiatives_manage).to eq(false)

            policy_group_template = group_leader.group.enterprise.user_roles.where(:id => group_leader.user_role_id).first.policy_group_template
            policy_group_template.initiatives_manage = true
            
            perform_enqueued_jobs do
                policy_group_template.save!
            end
        
            # ensure the job was called
            expect(PolicyGroupTemplateUpdateJob).to have_received(:perform_now)
            
            # ensure the group_leader was updated
            group_leader.reload
            expect(group_leader.groups_budgets_index).to eq(false)
        end
    end
end

require 'rails_helper'

RSpec.describe PolicyGroupTemplateUpdateJob, type: :job do
  let!(:user) { create(:user) }

  it 'calls set_default_policy_group on the user' do
    expect_any_instance_of(User).to receive(:set_default_policy_group)
    
    policy_group_template = user.enterprise.user_roles.where(:role_name => user.role).first.policy_group_template
    
    subject.perform(policy_group_template)
  end
end

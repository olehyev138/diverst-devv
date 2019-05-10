require 'rails_helper'

RSpec.describe PolicyGroupTemplateUpdateJob, type: :job do
  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  it 'calls set_default_policy_group on the user' do
    expect_any_instance_of(User).to receive(:set_default_policy_group)

    policy_group_template = enterprise.user_roles.where(role_name: user.user_role.role_name).first.policy_group_template

    subject.perform(policy_group_template)
  end
end

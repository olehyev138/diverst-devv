require 'rails_helper'

RSpec.describe ResetUserRoleJob, type: :job do
  let!(:user) { create(:user) }

  it "updates the user's role" do
    expect(user.user_role.role_name).to eq('admin')
    user_role = user.enterprise.user_roles.where(role_name: user.user_role.role_name).first
    subject.perform(user_role.id, user.enterprise_id)

    user.reload
    expect(user.user_role.role_name).to eq('user')
  end
end

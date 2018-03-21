require 'rails_helper'

RSpec.describe ResetUserRoleJob, type: :job do
  let!(:user) { create(:user) }

  it "updates the user's role" do
    expect(user.role).to eq("admin")
    user_role = user.enterprise.user_roles.where(:role_name => user.role).first
    subject.perform(user_role)
    
    user.reload
    expect(user.role).to eq("user")
  end
end

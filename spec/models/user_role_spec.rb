require 'rails_helper'

RSpec.describe UserRole do
  
  describe "when validating" do
    let(:user_role) { create(:user_role) }

    context 'test validations' do
      it { expect(user_role).to validate_presence_of(:role_name) }
      it { expect(user_role).to validate_presence_of(:role_type) }
      it { expect(user_role).to validate_presence_of(:enterprise) }
      it { expect(user_role).to validate_presence_of(:priority) }
    end
  end
  
  describe "#set_role_name" do
    it "downcases the name and adds underscores" do
      user_role = create(:user_role, :role_name => "GrOuP LeaDER")
      expect(user_role.role_name).to eq("group_leader")
    end
  end
  
  describe "#policy_group_template" do
    it "creates the default policy_group_template" do
      user_role = create(:user_role, :role_name => "GrOuP LeaDER")
      expect(user_role.policy_group_template).to_not be(nil)
    end
  end
  
  describe "#role_types" do
    it "returns the correct list of roles" do
      expect(UserRole.role_types).to eq(["admin", "user", "group"])
    end
  end
  
  describe "#available_priorities" do
    it "returns the correct list of available_priorities" do
      expect(UserRole.available_priorities).to eq((1..20).to_a)
    end
    
    it "returns the correct list of available_priorities" do
      enterprise =  create(:enterprise)
      array = [2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
      expect(UserRole.available_priorities(enterprise.user_roles.priorities)).to eq(array)
    end
  end
  
  describe "#can_destroy?" do
    it "returns false when role is the default" do
      enterprise = create(:enterprise)
      user_role = enterprise.user_roles.where(:default => true).first
      expect(user_role.can_destroy?).to be(false)
    end
    
    it "returns true when role is not the default" do
      enterprise = create(:enterprise)
      user_role = enterprise.user_roles.where.not(:default => true).first
      expect(user_role.can_destroy?).to be(true)
    end
  end
  
  describe "#reset_user_roles" do
    it "performs the job" do
      allow(ResetUserRoleJob).to receive(:perform_now).and_call_original
      
      admin = create(:user)
      expect(admin.role).to eq("admin")
      
      user_role = admin.enterprise.user_roles.where.not(:default => true).first
      expect(user_role.can_destroy?).to be(true)
      
      # remove the role
      user_role.destroy
      
      # ensure the job was called
      expect(ResetUserRoleJob).to have_received(:perform_now)
      
      # ensure the admin's role is now the default
      admin.reload
      expect(admin.role).to eq("user")
    end
  end
end

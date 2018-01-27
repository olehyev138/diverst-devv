require 'rails_helper'

RSpec.describe GroupLeader, type: :model do
  
  describe 'when validating' do
    let(:group_leader) { build_stubbed(:group_leader) }

    it{ expect(group_leader).to validate_presence_of(:position_name) }
    it{ expect(group_leader).to belong_to(:user) }
    it{ expect(group_leader).to belong_to(:group) }
  end
  
  describe "#default_group_contact" do
    it "raises an error" do
      group = create(:group)
      group_leader_1 = create(:group_leader, :group => group, :default_group_contact => true)
      expect(group_leader_1.valid?).to eq(true)
      
      group_leader_2 = build(:group_leader, :group => group, :default_group_contact => true)
      expect(group_leader_2.valid?).to eq(false)
      expect(group_leader_2.errors.full_messages.first).to eq("Default group contact You can choose ONLY ONE leader as the contact for this group")
    end
  end
  
  describe "#set_group_contact" do
    it "sets the group contact" do
      group = create(:group)
      group_leader_1 = build(:group_leader, :group => group, :default_group_contact => true)
      group_leader_1.save!
      
      expect(group.contact_email).to eq(group_leader_1.user.email)
    end
  end
end

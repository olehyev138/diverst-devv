require 'rails_helper'

RSpec.describe GroupLeader, type: :model do
  
  describe 'when validating' do
    let!(:enterprise) {create(:enterprise)}
    let(:group_leader) { build_stubbed(:group_leader) }

    it{ expect(group_leader).to validate_presence_of(:position_name) }
    it{ expect(group_leader).to belong_to(:user) }
    it{ expect(group_leader).to belong_to(:group) }
  end
  
  describe "#set_user_role" do
    context "when user is a basic user and role is elevated to group leader" do
      it "sets the basic users role to group_leader" do
        admin = create(:user, :role => "admin")
        enterprise = admin.enterprise
        basic_user = create(:user, :enterprise => enterprise, :role => "user")
        group = create(:group, :enterprise => enterprise)
        
        expect(basic_user.role).to eq("user")
        create(:group_leader, :role => "group_leader", :user => basic_user, :group => group)
        
        # expect the user role to change
        expect(basic_user.role).to eq("group_leader")
      end
    end
    
    context "when user has multiple group_leader roles but is removed as a group_leader with higher priority" do
      it "sets the group_leader role to group_treasurer" do
        admin = create(:user, :role => "admin")
        enterprise = admin.enterprise
        enterprise.user_roles.create(:role_name => "group_treasurer", :role_type => "group", :priority => 2)
        basic_user = create(:user, :enterprise => enterprise, :role => "user")
        group = create(:group, :enterprise => enterprise)
        
        expect(basic_user.role).to eq("user")
        create(:user_group, :group => group, :user => basic_user)
        group_leader = create(:group_leader, :role => "group_leader", :user => basic_user, :group => group)
        
        # expect the user role to change
        basic_user.reload
        expect(basic_user.role).to eq("group_leader")
        
        group_2 = create(:group, :enterprise => enterprise)
        create(:user_group, :group => group_2, :user => basic_user)
        group_treasurer = create(:group_leader, :role => "group_treasurer", :user => basic_user, :group => group_2)
        
        # expect the user role to NOT change
        basic_user.reload
        expect(basic_user.role).to eq("group_leader")
        
        # remove the group_leader
        group_leader.destroy
        
        # expect the user role to change to group_treasurer
        basic_user.reload
        expect(basic_user.role).to eq("group_treasurer")
        
        # remove the group_treasurer
        group_treasurer.destroy
        
        # expect the user role to change back to basic_user
        basic_user.reload
        expect(basic_user.role).to eq("user")
      end
    end
    
    context "when user has multiple group_leader roles and is elevated to an admin role" do
      it "sets the group_leader role to admin" do
        admin = create(:user, :role => "admin")
        enterprise = admin.enterprise
        enterprise.user_roles.create(:role_name => "group_treasurer", :role_type => "group", :priority => 2)
        basic_user = create(:user, :enterprise => enterprise, :role => "user")
        group = create(:group, :enterprise => enterprise)
        
        expect(basic_user.role).to eq("user")
        create(:user_group, :group => group, :user => basic_user)
        group_leader = create(:group_leader, :role => "group_leader", :user => basic_user, :group => group)
        
        # expect the user role to change
        basic_user.reload
        expect(basic_user.role).to eq("group_leader")
        
        group_2 = create(:group, :enterprise => enterprise)
        create(:user_group, :group => group_2, :user => basic_user)
        group_treasurer = create(:group_leader, :role => "group_treasurer", :user => basic_user, :group => group_2)
        
        # change the user's role to admin
        basic_user.role = "admin"
        basic_user.save!
        group_leader.save!
        
        expect(basic_user.role).to eq("admin")
        
        # remove the group_leader
        group_leader.destroy
        
        # expect the user role to NOT change
        basic_user.reload
        expect(basic_user.role).to eq("admin")
        
        # remove the group_treasurer
        group_treasurer.destroy
        
        # expect the user role to NOT change
        basic_user.reload
        expect(basic_user.role).to eq("admin")
      end
    end
  end
end

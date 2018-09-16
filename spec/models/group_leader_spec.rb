require 'rails_helper'

RSpec.describe GroupLeader, type: :model do

  describe 'when validating' do
    let!(:enterprise) {create(:enterprise)}
    let(:group_leader) { build_stubbed(:group_leader) }

    it{ expect(group_leader).to validate_presence_of(:position_name) }
    it{ expect(group_leader).to validate_presence_of(:group) }
    it{ expect(group_leader).to validate_presence_of(:user) }
    it{ expect(group_leader).to belong_to(:user) }
    it{ expect(group_leader).to belong_to(:group) }
  end
  
  describe "#set_user_role" do
    context "when user is a basic user and role is elevated to group leader" do
      it "sets the basic users role to group_leader" do
        enterprise = create(:enterprise)
        admin = create(:user, :user_role => enterprise.user_roles.where(:role_name => "admin").first, :enterprise => enterprise)
        enterprise = admin.enterprise
        basic_user = create(:user, :enterprise => enterprise, :user_role => enterprise.user_roles.where(:role_name => "user").first)
        group = create(:group, :enterprise => enterprise)
        
        expect(basic_user.user_role.role_name).to eq("user")
        create(:group_leader, :user_role => enterprise.user_roles.where(:role_name => "group_leader").first, :user => basic_user, :group => group)
        
        # expect the user role to change
        expect(basic_user.user_role.role_name).to eq("group_leader")
      end
    end
    
    context "when user is a basic user and role is elevated to group leader and then downgraded to another group leader role" do
      it "sets the basic users role to group_leader" do
        enterprise = create(:enterprise)
        admin = create(:user, :user_role => enterprise.user_roles.where(:role_name => "admin").first, :enterprise => enterprise)
        enterprise = admin.enterprise
        basic_user = create(:user, :enterprise => enterprise, :user_role => enterprise.user_roles.where(:role_name => "user").first)
        group = create(:group, :enterprise => enterprise)
        
        expect(basic_user.user_role.role_name).to eq("user")
        group_leader = create(:group_leader, :user_role => enterprise.user_roles.where(:role_name => "group_leader").first, :user => basic_user, :group => group)
        
        # expect the user role to change
        expect(basic_user.user_role.role_name).to eq("group_leader")
        
        # create another group role
        group_treasurer = create(:user_role, :enterprise => enterprise, :role_type => "group", :role_name => "Group Treasurer", :priority => 2)
        
        group_leader.user_role_id = group_treasurer.id
        group_leader.save
        
        basic_user.reload
        
        expect(basic_user.user_role.role_name).to eq("Group Treasurer")
      end
    end
    
    context "when user has multiple group_leader roles but is removed as a group_leader with higher priority" do
      it "sets the group_leader role to group_treasurer" do
        enterprise = create(:enterprise)
        enterprise.user_roles.create(:role_name => "group_treasurer", :role_type => "group", :priority => 2)
        basic_user = create(:user, :enterprise => enterprise, :user_role => enterprise.user_roles.where(:role_name => "user").first)
        group = create(:group, :enterprise => enterprise)
        
        
        expect(basic_user.user_role.role_name).to eq("user")
        create(:user_group, :group => group, :user => basic_user)
        group_leader = create(:group_leader, :user_role => enterprise.user_roles.where(:role_name => "group_leader").first, :user => basic_user, :group => group)
        
        # expect the user role to change
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("group_leader")
        
        group_2 = create(:group, :enterprise => enterprise)
        create(:user_group, :group => group_2, :user => basic_user)
        group_treasurer = create(:group_leader, :user_role => enterprise.user_roles.where(:role_name => "group_treasurer").first, :user => basic_user, :group => group_2)
        
        # expect the user role to NOT change
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("group_leader")

        # remove the group_leader
        group_leader.destroy!
        
        # expect the user role to change to group_treasurer
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("group_treasurer")
        
        # remove the group_treasurer
        group_treasurer.destroy
        
        # expect the user role to change back to basic_user
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("user")
      end
    end
    
    context "when user has multiple group_leader roles and is elevated to an admin role" do
      it "sets the group_leader role to admin" do
        enterprise = create(:enterprise)
        create(:user, :user_role => enterprise.user_roles.where(:role_name => "admin").first, :enterprise => enterprise)
        enterprise.user_roles.create(:role_name => "group_treasurer", :role_type => "group", :priority => 2)
        basic_user = create(:user, :enterprise => enterprise, :user_role => enterprise.user_roles.where(:role_name => "user").first)
        group = create(:group, :enterprise => enterprise)
        
        expect(basic_user.user_role.role_name).to eq("user")
        create(:user_group, :group => group, :user => basic_user)
        group_leader = create(:group_leader, :user_role => enterprise.user_roles.where(:role_name => "group_leader").first, :user => basic_user, :group => group)
        
        # expect the user role to change
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("group_leader")
        
        group_2 = create(:group, :enterprise => enterprise)
        create(:user_group, :group => group_2, :user => basic_user)
        group_treasurer = create(:group_leader, :user_role => enterprise.user_roles.where(:role_name => "group_treasurer").first, :user => basic_user, :group => group_2)
        
        # change the user's role to admin
        basic_user.user_role = enterprise.user_roles.where(:role_name => "admin").first
        basic_user.save!
        group_leader.save!
        
        expect(basic_user.user_role.role_name).to eq("admin")
        
        # remove the group_leader
        group_leader.destroy
        
        # expect the user role to NOT change
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("admin")
        
        # remove the group_treasurer
        group_treasurer.destroy
        
        # expect the user role to NOT change
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("admin")
      end
    end
  end
end

require 'rails_helper'

RSpec.describe UserGroup do
  describe "when validating" do
    let(:user_group){ build_stubbed(:user_group) }

    it { expect(user_group).to belong_to(:user) }
    it { expect(user_group).to belong_to(:group) }
  end

  describe "when scoping" do
    let(:user_group){ build_stubbed(:user_group) }

    context "top_participants" do
      let(:first){ create(:user_group, total_weekly_points: 30) }
      let(:third){ create(:user_group, total_weekly_points: 10) }
      let(:second){ create(:user_group, total_weekly_points: 20) }

      it { expect(UserGroup.top_participants(3)).to eq [first, second, third] }
      it { expect(user_group).to define_enum_for(:notifications_frequency).with([:hourly, :daily, :weekly, :disabled]) }
      it { expect(user_group).to define_enum_for(:notifications_date).with([:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]) }
    end

    context "notifications_status" do
      let!(:hourly){ create(:user_group, notifications_frequency: UserGroup.notifications_frequencies[:hourly]) }
      let!(:disabled){ create(:user_group, notifications_frequency: UserGroup.notifications_frequencies[:disabled]) }
      let!(:daily){ create(:user_group, notifications_frequency: UserGroup.notifications_frequencies[:daily]) }

      it "returns user_group with specific notifications_frequency" do
        expect(UserGroup.notifications_status("hourly")).to eq [hourly]
      end
    end

    describe ".accepted_users" do
      let!(:hourly){ create(:user_group, notifications_frequency: UserGroup.notifications_frequencies[:hourly]) }
      let!(:disabled){ create(:user_group, notifications_frequency: UserGroup.notifications_frequencies[:disabled]) }
      let!(:daily){ create(:user_group, notifications_frequency: UserGroup.notifications_frequencies[:daily]) }

      let(:enterprise) { create :enterprise }
      let(:user1) { create :user, enterprise: enterprise }
      let(:user2) { create :user, enterprise: enterprise }

      let(:group) { create :group, enterprise: enterprise }

      let(:user_group1) { create :user_group, user: user1, group: group, accepted_member: true }
      let(:user_group2) { create :user_group, user: user2, group: group, accepted_member: false }

      context 'with pending users enabled' do
        before { group.update(pending_users: 'enabled') }

        it 'returns only accepted member' do
          expect(group.user_groups.accepted_users).to include user_group1
          expect(group.user_groups.accepted_users).to_not include user_group2
        end
      end

      context 'with pending users disabled' do
        before { group.update(pending_users: 'disabled') }

        it 'returns all members' do
          expect(group.user_groups.accepted_users).to include user_group1
          expect(group.user_groups.accepted_users).to include user_group2
        end
      end

      it "returns user_group with specific notifications_frequency" do
        expect(UserGroup.notifications_status("hourly")).to eq [hourly]
      end
    end
  end

  describe 'when describing callbacks' do
    let!(:user){ create(:user) }

    it "should reindex user on elasticsearch after create" do
      user_group = build(:user_group, user:  user)
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'update',
          index: User.es_index_name(enterprise: user_group.user.enterprise),
          record_id: user_group.user.id
        )
        user_group.save
      end
    end

    it "should reindex user on elasticsearch after destroy" do
      user_group = create(:user_group, user:  user)
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'update',
          index: User.es_index_name(enterprise: user_group.user.enterprise),
          record_id: user_group.user.id
        )
        user_group.destroy
      end
    end
  end

  describe "#notifications_date" do
    it "returns sunday" do
      user_group = create(:user_group, :notifications_date => 0)
      expect(user_group.notifications_date).to eq("sunday")
    end
    it "returns default monday" do
      user_group = create(:user_group, :notifications_date => 1)
      expect(user_group.notifications_date).to eq("monday")
    end
    it "returns tuesday" do
      user_group = create(:user_group, :notifications_date => 2)
      expect(user_group.notifications_date).to eq("tuesday")
    end
    it "returns wednesday" do
      user_group = create(:user_group, :notifications_date => 3)
      expect(user_group.notifications_date).to eq("wednesday")
    end
    it "returns thursday" do
      user_group = create(:user_group, :notifications_date => 4)
      expect(user_group.notifications_date).to eq("thursday")
    end
    it "returns default friday" do
      user_group = create(:user_group)
      expect(user_group.notifications_date).to eq("friday")
    end
    it "returns saturday" do
      user_group = create(:user_group, :notifications_date => 6)
      expect(user_group.notifications_date).to eq("saturday")
    end
  end

  describe "#string_for_field" do
    it "returns the string field" do
      select_field = SelectField.new(:type => "SelectField", :title => "Gender", :options_text => "Male\nFemale")
      select_field.save!
      user_group = create(:user_group, :data => "{\"#{select_field.id}\":[\"Female\"]}")
      expect(user_group.string_for_field(select_field)).to eq("Female")
    end
  end
  
  describe "#remove_leader_role" do
    context "when user is a basic user and role is elevated to group leader" do
      it "sets the basic users role to group_leader then back to basic user when removed as group member" do
        enterprise = create(:enterprise)
        admin = create(:user, :user_role => enterprise.user_roles.where(:role_name => "admin").first, :enterprise => enterprise)
        enterprise = admin.enterprise
        basic_user = create(:user, :enterprise => enterprise, :user_role => enterprise.user_roles.where(:role_name => "user").first)
        group = create(:group, :enterprise => enterprise)
        
        expect(basic_user.user_role.role_name).to eq("user")
        user_group = create(:user_group, :user => basic_user, :group => group)
        create(:group_leader, :user_role => enterprise.user_roles.where(:role_name => "group_leader").first, :user => basic_user, :group => group)
        
        # expect the user role to change
        expect(basic_user.user_role.role_name).to eq("group_leader")
        
        # remove the group member and check the role
        user_group.destroy
        basic_user.reload
        
        expect(basic_user.user_role.role_name).to eq("user")
        expect(GroupLeader.where(:user_id => basic_user.id).count).to eq(0)
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
        user_group = create(:user_group, :group => group_2, :user => basic_user)
        create(:group_leader, :user_role => enterprise.user_roles.where(:role_name => "group_treasurer").first, :user => basic_user, :group => group_2)
        
        # expect the user role to NOT change
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("group_leader")

        # remove the group_leader
        group_leader.destroy!
        
        # expect the user role to change to group_treasurer
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("group_treasurer")
        
        # remove the group_treasurer group member role
        user_group.destroy
        
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
        user_group = create(:user_group, :group => group_2, :user => basic_user)
        create(:group_leader, :user_role => enterprise.user_roles.where(:role_name => "group_treasurer").first, :user => basic_user, :group => group_2)
        
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
        
        # remove the group_treasurer group member role
        user_group.destroy
        
        # expect the user role to NOT change
        basic_user.reload
        expect(basic_user.user_role.role_name).to eq("admin")
      end
    end
  end
end

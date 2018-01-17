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
      user_group = create(:user_group)
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
    it "returns friday" do
      user_group = create(:user_group, :notifications_date => 5)
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
end

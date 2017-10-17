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
end

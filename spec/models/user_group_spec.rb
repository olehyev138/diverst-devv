require 'rails_helper'

RSpec.describe UserGroup do
  describe "when validating" do
    let(:user_group){ build_stubbed(:user_group) }

    it { expect(user_group).to define_enum_for(:notifications_frequency).with([:real_time, :daily, :weekly, :disabled]) }
  end

  describe "when scoping" do
    let!(:real_time){ create(:user_group, notifications_frequency: UserGroup.notifications_frequencies[:real_time]) }
    let!(:disabled){ create(:user_group, notifications_frequency: UserGroup.notifications_frequencies[:disabled]) }
    let!(:daily){ create(:user_group, notifications_frequency: UserGroup.notifications_frequencies[:daily]) }

    it "returns user_group with specific notifications_frequency" do
      expect(UserGroup.notifications_status("real_time")).to eq [real_time]
    end
  end
end

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

      it { expect(UserGroup.top_participants).to eq [first, second, third] }
    end
  end
end

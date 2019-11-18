require 'rails_helper'

RSpec.describe SegmentMembersDownloadJob, type: :job do
  describe '#perform' do
    it "creates a downloadable csv file when there's no group" do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)
      segment = create(:segment, enterprise: enterprise)
      create(:users_segment, user: user, segment: segment)

      expect { subject.perform(user.id, segment.id) }
        .to change(CsvFile, :count).by(1)
    end

    it "creates a downloadable csv file when there's a group" do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)
      group = create(:group, enterprise: enterprise)
      create(:user_group, user: user, group: group)
      segment = create(:segment, enterprise: enterprise)
      create(:users_segment, user: user, segment: segment)

      expect { subject.perform(user.id, segment.id, group.id) }
        .to change(CsvFile, :count).by(1)
    end
  end
end

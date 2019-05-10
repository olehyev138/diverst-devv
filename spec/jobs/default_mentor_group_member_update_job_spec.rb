require 'rails_helper'

RSpec.describe DefaultMentorGroupMemberUpdateJob, type: :job do
  include ActiveJob::TestHelper

  context 'when mentee and mentor are false' do
    it 'does not add user to group' do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)
      group = create(:group, enterprise: enterprise, default_mentor_group: true)

      subject.perform(user.id, false, false)

      expect(group.members.count).to eq(0)
    end
  end

  context 'when either mentee or mentor are true' do
    it 'adds user to group' do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise, mentee: true)
      group = create(:group, enterprise: enterprise, default_mentor_group: true)

      subject.perform(user.id, true, false)

      expect(group.members.count).to eq(1)
    end
  end
end

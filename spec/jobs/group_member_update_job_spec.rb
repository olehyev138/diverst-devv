require 'rails_helper'

RSpec.describe GroupMemberUpdateJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'calls elasticsearch' do
      user = create(:user)
      group = create(:group, enterprise: user.enterprise)
      create(:user_group, user: user, group: group)

      allow(user).to receive(:__elasticsearch__).and_call_original

      expect_any_instance_of(User).to receive(:__elasticsearch__)

      subject.perform(user.id)
    end
  end
end

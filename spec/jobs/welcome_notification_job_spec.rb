require 'rails_helper'

RSpec.describe WelcomeNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise, disable_emails: false) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise: enterprise) }

  context 'sends welcome notification to new group member' do
    it 'when enterprise emails is enabled' do
      mailer = double('mailer')

      expect(WelcomeMailer).to receive(:notification) { mailer }
      expect(mailer).to receive(:deliver_now)
      subject.perform(group.id, user.id)
    end
  end
end

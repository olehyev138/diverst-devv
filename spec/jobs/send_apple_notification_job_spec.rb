require 'rails_helper'

RSpec.describe SendAppleNotificationJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'pushes the notification' do
      apn = OpenStruct.new({ push: true, certificate: '' })
      allow(Houston::Client).to receive(:development).and_return(apn)
      notification = OpenStruct.new({ alert: '', badge: 1, sound: '', category: '', custom_data: {}, error: true })
      allow(Houston::Notification).to receive(:new).and_return(notification)
      allow(apn).to receive(:push).and_return(true)

      subject.perform('token', 'message', {})

      expect(apn).to have_received(:push)
    end
  end
end

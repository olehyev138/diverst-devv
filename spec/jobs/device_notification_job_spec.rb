require 'rails_helper'

RSpec.describe DeviceNotificationJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'pushes the notification' do
      fcm = OpenStruct.new({ send: true })
      allow(FCM).to receive(:new).and_return(fcm)
      allow(fcm).to receive(:send)

      device = create(:device)
      subject.perform(device.user_id, { "notification": {
          "title": 'New Survey from Diverst!',
          "body": 'Did this work?'
        } })

      expect(fcm).to have_received(:send)
    end
  end
end

require 'rails_helper'

RSpec.describe SendAndroidNotificationJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    xit 'pushes the notification' do
      gcm = OpenStruct.new({ send: true })
      allow(GCM).to receive(:new).and_return(gcm)
      allow(gcm).to receive(:send)

      subject.perform('token', 'message', {})

      expect(gcm).to have_received(:send)
    end
  end
end

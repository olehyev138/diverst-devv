require 'rails_helper'

RSpec.describe Device, :type => :model do
    
  describe "notify" do
    it "sends message to apple device" do
      expect(SendAppleNotificationJob).to receive(:perform_later)
      device = create(:device)
      device.notify("", {})
    end
    
    it "sends message to android device" do
      expect(SendAndroidNotificationJob).to receive(:perform_later)
      device = create(:device, :platform => "android")
      device.notify("", {})
    end
  end
end

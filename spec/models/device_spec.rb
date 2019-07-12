require 'rails_helper'

RSpec.describe Device, type: :model do
  describe 'when validating' do
    let(:device) { create(:device) }

    it { expect(device).to validate_presence_of(:user) }
    it { expect(device).to validate_presence_of(:token) }
    it { expect(device).to validate_uniqueness_of(:token).with_message('has already been taken') }
    it { expect(device).to belong_to(:user) }
  end

  describe '#token' do
    it 'raises an error when duplicate token is attempted to save' do
      user_1 = create(:user)
      user_2 = create(:user, enterprise: user_1.enterprise)
      device_1 = create(:device, user: user_1)
      device_2 = build(:device, user: user_2, token: device_1.token)

      expect(device_2.valid?).to be false
      expect(device_2.errors.full_messages.first).to eq('Token has already been taken')
    end
  end
end

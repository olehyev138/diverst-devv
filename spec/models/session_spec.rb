require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'when validating' do
    let(:session) { build_stubbed(:session) }

    it { expect(session).to belong_to(:user) }

    it { is_expected.to validate_presence_of(:token).with_message('Value Required') }
    it { is_expected.to validate_presence_of(:expires_at).with_message('Value Required') }
    it { is_expected.to validate_presence_of(:user).with_message('Value Required') }
  end
end

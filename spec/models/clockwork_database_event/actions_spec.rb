require 'rails_helper'

RSpec.describe ClockworkDatabaseEvent::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) { [:frequency_period] }

    it { expect(ClockworkDatabaseEvent.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end

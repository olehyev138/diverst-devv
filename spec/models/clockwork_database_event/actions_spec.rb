require 'rails_helper'

RSpec.describe ClockworkDatabaseEvent::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(ClockworkDatabaseEvent.base_preloads.include?(:frequency_period)).to eq true }
  end
end

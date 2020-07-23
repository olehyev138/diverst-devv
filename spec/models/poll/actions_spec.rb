require 'rails_helper'

RSpec.describe Poll::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(Poll.base_preloads.include?(:fields)).to eq true }
    it { expect(Poll.base_preloads.include?(:groups)).to eq true }
    it { expect(Poll.base_preloads.include?(:segments)).to eq true }
    it { expect(Poll.base_preloads.include?(:enterprise)).to eq true }
  end
end

require 'rails_helper'

RSpec.describe Campaign::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(Campaign.base_preloads.include?(:questions)).to eq true }
    it { expect(Campaign.base_preloads.include?(:image_attachment)).to eq true }
    it { expect(Campaign.base_preloads.include?(:banner_attachment)).to eq true }
    it { expect(Campaign.base_preloads.include?(:groups)).to eq true }
  end
end

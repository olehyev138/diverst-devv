require 'rails_helper'

RSpec.describe NewsLink::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(NewsLink.base_preloads.include?(:author)).to eq true }
    it { expect(NewsLink.base_preloads.include?(:group)).to eq true }
    it { expect(NewsLink.base_preloads.include?(:comments)).to eq true }
    it { expect(NewsLink.base_preloads.include?(:photos)).to eq true }
    it { expect(NewsLink.base_preloads.include?(:picture_attachment)).to eq true }
  end
end

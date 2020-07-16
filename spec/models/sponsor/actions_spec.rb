require 'rails_helper'

RSpec.describe Sponsor::Actions, type: :model do
  describe 'valid_scopes' do
    it { expect(Sponsor.valid_scopes.include?('group_sponsor')).to eq true }
    it { expect(Sponsor.valid_scopes.include?('enterprise_sponsor')).to eq true }
  end

  describe 'base_attributes_preloads' do
    it { expect(Sponsor.base_attributes_preloads.include?(:sponsor_media_attachment)).to eq true }
  end
end

require 'rails_helper'

RSpec.describe Resource::Actions, type: :model do
  describe 'valid_scopes' do
    it { expect(Resource.valid_scopes.include?('archived')).to eq true }
    it { expect(Resource.valid_scopes.include?('not_archived')).to eq true }
  end

  describe 'base_preloads' do
    it { expect(Resource.base_preloads.include?(:folder)).to eq true }
    it { expect(Resource.base_preloads.include?(:file_attachment)).to eq true }
  end
end

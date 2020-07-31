require 'rails_helper'

RSpec.describe Resource::Actions, type: :model do
  describe 'valid_scopes' do
    let!(:valid_scopes) { %w(not_archived archived) }
    it { expect(Resource.valid_scopes).to eq valid_scopes }
  end

  describe 'base_preloads' do
    let!(:base_preloads) { [:folder, :file_attachment] }
    it { expect(Resource.base_preloads).to eq base_preloads }
  end
end

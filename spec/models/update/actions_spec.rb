require 'rails_helper'

RSpec.describe Update::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(Update.base_preloads.include?(:field_data)).to eq true }
    it { expect(Update.base_preloads.include?(:previous)).to eq true }
    it { expect(Update.base_preloads.include?(:next)).to eq true }
    it { expect(Update.base_preloads.include?({ field_data: [:field, { field: [:field_definer] }],
                                                previous: [:field_data, { field_data: [:field, { field: [:field_definer] }] }] })).to eq true }
  end

  describe 'lesser_preloads' do
    it { expect(Update.lesser_preloads.include?(:field_data)).to eq true }
    it { expect(Update.lesser_preloads.include?({ field_data: [:field, { field: [:field_definer] }] })).to eq true }
  end
end

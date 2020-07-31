require 'rails_helper'

RSpec.describe FieldData::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :field,
          field: [:field_definer]
      ]
    }

    it { expect(FieldData.base_preloads).to eq base_preloads }
  end
end

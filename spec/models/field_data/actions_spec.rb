require 'rails_helper'

RSpec.describe FieldData::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(FieldData.base_preloads.include?(:field)).to eq true }
  end
end

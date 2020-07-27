require 'rails_helper'

RSpec.describe Field::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(Field.base_preloads.include?(:field_definer)).to eq true }
  end
end

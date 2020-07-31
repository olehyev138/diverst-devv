require 'rails_helper'

RSpec.describe Field::Actions, type: :model do
  describe 'base_preloads' do
    let!(:base_preloads) { [:field_definer] }
    it { expect(Field.base_preloads).to eq base_preloads }
  end
end

require 'rails_helper'

RSpec.describe TextField, type: :model do
  describe 'operators' do
    let(:operators) {  TextField.new.operators }

    it 'includes equals' do
      expect(operators).to include Field::OPERATORS[:equals]
    end

    it 'includes is_not' do
      expect(operators).to include Field::OPERATORS[:is_not]
    end

    it 'includes is_part_of' do
      expect(operators).to include Field::OPERATORS[:is_part_of]
    end
  end
end

require 'rails_helper'

RSpec.describe GroupsField, type: :model do
  describe '#format_value_name' do
    it 'returns Deleted ERG' do
      groups_field = GroupsField.create(attributes_for(:groups_field))
      expect(groups_field.format_value_name(1)).to eq('Deleted ERG')
    end
  end
end

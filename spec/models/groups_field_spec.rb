require 'rails_helper'

RSpec.describe GroupsField, type: :model do
  describe 'elasticsearch_field' do
    it 'returns elasticsearch field' do
      groups_field = GroupsField.create(attributes_for(:groups_field))
      expect(groups_field.elasticsearch_field).to eq 'group.name'
    end
  end

  describe '#format_value_name' do
    it 'returns Deleted ERG' do
      groups_field = GroupsField.create(attributes_for(:groups_field))
      expect(groups_field.format_value_name(1)).to eq('Deleted ERG')
    end
  end

  describe 'private' do
    before do
      GroupsField.send(:public, *GroupsField.private_instance_methods)
    end

    it 'does init' do
      groups_field = GroupsField.create(attributes_for(:groups_field))
      expect(groups_field.title).to eq('ERGs')
      expect(groups_field.elasticsearch_only).to eq(true)
    end
  end
end

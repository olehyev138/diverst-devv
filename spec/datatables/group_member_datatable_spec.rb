require 'rails_helper'

RSpec.describe GroupMemberDatatable do
  let(:user) { create(:user) }
  let(:group) { create(:group, enterprise: user.enterprise) }

  describe '#sortable_columns' do
    it 'returns the sortable_columns' do
      table = GroupMemberDatatable.new(OpenStruct.new({ current_user: user }), group, group.members)
      expect(table.sortable_columns).to eq(['User.first_name', 'User.active'])
    end
  end

  describe '#searchable_columns' do
    it 'returns the searchable_columns' do
      table = GroupMemberDatatable.new(OpenStruct.new({ current_user: user }), group, group.members)
      expect(table.searchable_columns).to eq(['User.first_name', 'User.last_name'])
    end
  end
end

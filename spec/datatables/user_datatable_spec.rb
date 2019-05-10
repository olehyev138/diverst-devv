require 'rails_helper'

RSpec.describe UserDatatable do
  let(:user) { create(:user) }

  describe '#sortable_columns' do
    it 'returns the sortable_columns' do
      table = UserDatatable.new(OpenStruct.new({ current_user: user }), [user])
      expect(table.sortable_columns).to eq(['User.first_name', 'User.last_name', 'User.email'])
    end
  end

  describe '#searchable_columns' do
    it 'returns the searchable_columns' do
      table = UserDatatable.new(OpenStruct.new({ current_user: user }), [user])
      expect(table.searchable_columns).to eq(['User.first_name', 'User.last_name', 'User.email'])
    end
  end
end

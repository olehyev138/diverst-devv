require 'rails_helper'

RSpec.describe MentoringDatatable do
  let(:user) { create(:user) }

  describe '#sortable_columns' do
    it 'returns the sortable_columns' do
      table = MentoringDatatable.new(nil, [user], user, true)
      expect(table.sortable_columns).to eq(['User.first_name', 'User.email'])
    end
  end

  describe '#searchable_columns' do
    it 'returns the searchable_columns' do
      table = MentoringDatatable.new(nil, [user], user, false)
      expect(table.searchable_columns).to eq([])
    end
  end
end

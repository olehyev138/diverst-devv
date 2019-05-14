require 'rails_helper'

RSpec.describe SegmentMemberDatatable do
  let(:user) { create(:user) }
  let(:segment) { create(:segment, enterprise: user.enterprise) }

  describe '#sortable_columns' do
    it 'returns the sortable_columns' do
      table = SegmentMemberDatatable.new(segment, segment.members)
      expect(table.sortable_columns).to eq(['User.first_name', 'User.last_name', 'User.email'])
    end
  end

  describe '#searchable_columns' do
    it 'returns the searchable_columns' do
      table = SegmentMemberDatatable.new(segment, segment.members)
      expect(table.searchable_columns).to eq(['User.first_name', 'User.last_name', 'User.email'])
    end
  end
end

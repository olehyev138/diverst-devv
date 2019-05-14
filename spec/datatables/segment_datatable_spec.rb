require 'rails_helper'

RSpec.describe SegmentDatatable do
  let(:enterprise) { create :enterprise }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:segments) { create_list(:segment, 2, enterprise: enterprise) }

  describe '#sortable_columns' do
    it 'returns the sortable_columns' do
      table = SegmentDatatable.new(OpenStruct.new({ current_user: user }), segments)
      expect(table.sortable_columns).to eq(['Segment.name', 'Segment.all_rules_count', 'Segment.created_at.to_s'])
    end
  end

  describe '#searchable_columns' do
    it 'returns the searchable_columns' do
      table = SegmentDatatable.new(OpenStruct.new({ current_user: user }), segments)
      expect(table.searchable_columns).to eq(['Segment.name'])
    end
  end
end

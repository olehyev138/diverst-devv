require 'rails_helper'

RSpec.describe SegmentDatatable do
  let(:enterprise) { create :enterprise }
  let(:segments) { create_list(:segment, 2, enterprise: enterprise) }

  describe '#sortable_columns' do
  	it 'returns the sortable_columns' do 
  		table = SegmentDatatable.new(nil, segments)
  		expect(table.sortable_columns).to eq(['Segment.name', 'Segment.members.uniq.count', 'Segment.rules.count', 'Segment.created_at.to_s'])
  	end
  end

  describe '#searchable_columns' do
  	it 'returns the searchable_columns' do
  		table = SegmentDatatable.new(nil, segments)
  		expect(table.searchable_columns).to eq(['Segment.name'])
  	end
  end
end
require 'rails_helper'

RSpec.describe CacheSegmentMembersJob, type: :job do
  it 'removes the segment members' do
    enterprise = create(:enterprise)
    select_field = create(:select_field, type: 'SelectField', title: 'Gender', options_text: "Male\nFemale", field_definer: enterprise)

    segment = create(:segment, enterprise: enterprise)
    create(:segment_field_rule, segment: segment, field: select_field, operator: Field::OPERATORS[:equals_any_of], data: ['Female'].to_json)

    user = create(:user, enterprise: enterprise)
    create(:users_segment, user: user, segment: segment)

    expect(segment.members.count).to eq(1)

    worker = CacheSegmentMembersJob.new
    worker.perform(segment.id)

    expect(segment.members.count).to eq(0)
  end

  it 'adds the segment members' do
    enterprise = create(:enterprise)

    select_field = enterprise.fields.new(type: 'SelectField', title: 'Gender', options_text: "Male\nFemale", field_definer: enterprise)
    select_field.save!

    segment = create(:segment, enterprise: enterprise)
    create(:segment_field_rule, segment: segment, field: select_field, operator: Field::OPERATORS[:equals_any_of], data: ['Female'].to_json)

    user = create(:user, enterprise: enterprise, active: true)
    user[select_field] = ['Female']

    expect(segment.members.count).to eq(0)

    worker = CacheSegmentMembersJob.new
    worker.perform(segment.id)

    expect(segment.members.count).to eq(1)
  end
end

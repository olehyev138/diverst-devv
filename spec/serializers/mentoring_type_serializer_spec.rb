require 'rails_helper'

RSpec.describe MentoringTypeSerializer, type: :serializer do
  it 'returns associations' do
    mentoring_type = create(:mentoring_type)

    serializer = MentoringTypeSerializer.new(mentoring_type, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(mentoring_type.id)
    expect(serializer.serializable_hash[:name]).to eq(mentoring_type.name)
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end

require 'rails_helper'

RSpec.describe MentorshipAvailabilitySerializer, type: :serializer do
  it 'returns mentorship availability' do
    mentorship_availability = create(:mentorship_availability)

    serializer = MentorshipAvailabilitySerializer.new(mentorship_availability, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(mentorship_availability.id)
    expect(serializer.serializable_hash[:user_id]).to eq(mentorship_availability.user_id)
    expect(serializer.serializable_hash[:day]).to eq(mentorship_availability.day)
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end

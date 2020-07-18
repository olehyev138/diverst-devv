require 'rails_helper'

RSpec.describe MentoringRequestLiteSerializer, type: :serializer do
  it 'returns mentoring request lite' do
    mentoring_request = create(:mentoring_request)

    serializer = MentoringRequestLiteSerializer.new(mentoring_request, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(mentoring_request.id)
    expect(serializer.serializable_hash[:status]).to eq(mentoring_request.status)
    expect(serializer.serializable_hash[:sender_id]).to eq(mentoring_request.sender_id)
    expect(serializer.serializable_hash[:receiver_id]).to eq(mentoring_request.receiver_id)
  end
end

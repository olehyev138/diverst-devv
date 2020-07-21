require 'rails_helper'

RSpec.describe MentoringRequestSerializer, type: :serializer do
  it 'returns associations' do
    sender = create(:user)
    receiver = create(:user)
    mentoring_request = create(:mentoring_request, sender_id: sender.id, receiver_id: receiver.id)

    serializer = MentoringRequestSerializer.new(mentoring_request, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(mentoring_request.id)
    expect(serializer.serializable_hash[:sender]).to_not be nil
    expect(serializer.serializable_hash[:receiver]).to_not be nil
  end
end

require 'rails_helper'

RSpec.describe UserMentorshipLiteSerializer, type: :serializer do
  it 'returns mentorship lite' do
    enterprise = create(:enterprise)
    mentor = create(:user, enterprise: enterprise)
    create_list(:mentorship_interest, 3, user_id: mentor.id)
    serializer = UserMentorshipLiteSerializer.new(mentor, scope: serializer_scopes(mentor))

    expect(serializer.serializable_hash[:id]).to eq mentor.id
    expect(serializer.serializable_hash[:enterprise_id]).to  eq enterprise.id
    expect(serializer.serializable_hash[:interests]).to_not be ''
  end
end

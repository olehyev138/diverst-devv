require 'rails_helper'

RSpec.describe MentorshipSessionSerializer, type: :serializer do
  it 'returns mentorship session' do
    mentorship_session = create(:mentorship_session)

    serializer = MentorshipSessionSerializer.new(mentorship_session, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq(mentorship_session.id)
    expect(serializer.serializable_hash[:user_id]).to eq(mentorship_session.user_id)
    expect(serializer.serializable_hash[:mentoring_session_id]).to eq(mentorship_session.mentoring_session_id)
  end
end

require 'rails_helper'

RSpec.describe MentoringSessionSerializer, type: :serializer do
  it 'returns mentoring session' do
    mentoring_session = create(:mentoring_session)

    serializer = MentoringSessionSerializer.new(mentoring_session, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(mentoring_session.id)
    expect(serializer.serializable_hash[:status]).to eq(mentoring_session.status)
    expect(serializer.serializable_hash[:start]).to eq(mentoring_session.start)
    expect(serializer.serializable_hash[:end]).to eq(mentoring_session.end)
  end
end

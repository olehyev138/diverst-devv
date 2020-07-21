require 'rails_helper'

RSpec.describe MentoringSerializer, type: :serializer do
  it 'returns associations' do
    mentor =  create(:user)
    mentee =  create(:user)
    mentoring = create(:mentoring, mentor_id: mentor.id, mentee_id: mentee.id)

    serializer = MentoringSerializer.new(mentoring, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:mentee]).to_not be nil
    expect(serializer.serializable_hash[:mentor]).to_not be nil
  end
end

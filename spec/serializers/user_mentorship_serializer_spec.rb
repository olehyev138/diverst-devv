require 'rails_helper'

RSpec.describe UserMentorshipSerializer, type: :serializer do
  let(:mentor) { create(:user) }
  let(:mentee) { create(:user) }
  let(:mentoring) { create(:mentoring, mentor: mentor, mentee: mentee) }
  it 'returns mentorship mentees' do
    create_list(:mentorship_interest, 3, user_id: mentor.id)
    serializer = UserMentorshipSerializer.new(mentor, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:mentees]).to_not be nil
    expect(serializer.serializable_hash[:interests]).to_not be ''
    expect(serializer.serializable_hash[:mentors]).to eq []
  end
  it 'returns mentorship monters' do
    create_list(:mentorship_interest, 3, user_id: mentee.id)
    serializer = UserMentorshipSerializer.new(mentee, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:mentees]).to eq []
    expect(serializer.serializable_hash[:interests]).to_not be ''
    expect(serializer.serializable_hash[:mentors]).to_not be nil
  end
end

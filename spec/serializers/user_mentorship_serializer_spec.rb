require 'rails_helper'

RSpec.describe UserMentorshipSerializer, type: :serializer do
  let!(:mentor) { create(:user, mentor: true, mentees_count: 1) }
  let!(:mentee) { create(:user, mentee: true, mentors_count: 1) }
  let!(:mentoring) { create(:mentoring, mentor: mentor, mentee: mentee) }
  it 'returns mentorship mentees' do
    create_list(:mentorship_interest, 3, user_id: mentor.id)
    serializer = UserMentorshipSerializer.new(mentor, scope: serializer_scopes(mentor), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq mentor.id
    expect(serializer.serializable_hash[:mentees]).to_not eq []
    expect(serializer.serializable_hash[:interests]).to_not be ''
    expect(serializer.serializable_hash[:mentors]).to eq []
  end
  it 'returns mentorship monters' do
    create_list(:mentorship_interest, 3, user_id: mentee.id)
    serializer = UserMentorshipSerializer.new(mentee, scope: serializer_scopes(mentee), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:mentees]).to eq []
    expect(serializer.serializable_hash[:interests]).to_not be ''
    expect(serializer.serializable_hash[:mentors]).to_not eq []
  end
end

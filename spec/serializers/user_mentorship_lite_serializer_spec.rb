require 'rails_helper'

RSpec.describe UserMentorshipLiteSerializer, type: :serializer do
  let(:enterprise) { create(:enterprise) }
  let(:mentor) { create(:user, enterprise: enterprise) }
  let(:serializer) { UserMentorshipLiteSerializer.new(mentor, scope: serializer_scopes(mentor)) }

  before do
    create_list(:mentorship_interest, 3, user_id: mentor.id)
  end

  include_examples 'permission container', :serializer

  it 'returns mentorship lite' do
    expect(serializer.serializable_hash[:id]).to eq mentor.id
    expect(serializer.serializable_hash[:enterprise_id]).to  eq enterprise.id
    expect(serializer.serializable_hash[:interests]).to_not be ''
  end
end

require 'rails_helper'

RSpec.describe MentoringInterestSerializer, type: :serializer do
  it 'returns mentoring interest' do
    mentoring_interest = create(:mentoring_interest)

    serializer = MentoringInterestSerializer.new(mentoring_interest, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(mentoring_interest.id)
    expect(serializer.serializable_hash[:name]).to eq(mentoring_interest.name)
  end
end

require 'rails_helper'

RSpec.describe Mentoring, type: :model do
  let!(:enterprise) { create(:enterprise) }
  let!(:mentor) { create(:user, enterprise: enterprise) }
  let!(:mentee) { create(:user, enterprise: enterprise) }
  let!(:mentoring) { create(:mentoring, mentor: mentor, mentee: mentee) }

  describe 'test associations and validations' do
    it { expect(mentoring).to validate_presence_of(:mentee) }
    it { expect(mentoring).to validate_presence_of(:mentor) }

    it { expect(mentoring).to belong_to(:mentee).class_name('User') }
    it { expect(mentoring).to belong_to(:mentor).class_name('User') }
  end

  describe '.active_mentorships' do
    it 'returns active_mentorships for an enterprise' do
      expect(Mentoring.active_mentorships(enterprise)).to eq([mentoring])
    end
  end

  describe '#as_indexed_json' do
    it 'returns json' do
      expect(mentoring.as_indexed_json)
      .to eq(
        { 'mentee' =>
          { 'active' => true,
            'enterprise_id' => enterprise.id,
            'id' => mentee.id },
          'mentor' => {
              'active' => true,
              'enterprise_id' => enterprise.id,
              'id' => mentor.id
          } }
      )
    end
  end
end

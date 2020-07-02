require 'rails_helper'

RSpec.describe MentoringType, type: :model do
  describe 'validations' do
    let(:mentoring_type) { build_stubbed(:mentoring_type) }

    it { expect(mentoring_type).to validate_length_of(:name).is_at_most(191) }
    it { expect(mentoring_type).to validate_presence_of(:name) }

    context 'uniqueness' do
      let(:uniqueness_mentoring_type) { build(:mentoring_type) }
      it { expect(uniqueness_mentoring_type).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:enterprise_id) }
    end
  end
end

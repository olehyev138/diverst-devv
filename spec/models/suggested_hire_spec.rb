require 'rails_helper'

RSpec.describe SuggestedHire, type: :model do
  let(:suggested_hire) { build(:suggested_hire, email: 'derek@diverst.com') }

  describe 'tests associations and validations' do
    it { expect(suggested_hire).to belong_to(:user) }
    it { expect(suggested_hire).to belong_to(:group) }
    it { expect(suggested_hire).to validate_uniqueness_of(:email) }
    it { expect(suggested_hire).to have_attached_file(:resume) }
    it { expect(suggested_hire).to validate_attachment_content_type(:resume).allowing('text/plain', 'application/pdf') }
  end

  describe '#resume_extension' do
    it "returns '' " do
      suggested_hire = create(:suggested_hire, email: 'derek@diverst.com')
      expect(suggested_hire.resume_extension).to eq('')
    end
  end
end

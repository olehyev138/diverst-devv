require 'rails_helper'

RSpec.describe SuggestedHire, type: :model do
  let(:suggested_hire) { build(:suggested_hire, suggested_hire_id: create(:user).id) }

  describe 'tests associations and validations' do
    it { expect(suggested_hire).to belong_to(:user) }
    it { expect(suggested_hire).to belong_to(:group) }
    it { expect(suggested_hire).to belong_to(:suggested_hire).class_name('User').with_foreign_key(:suggested_hire_id) }
    it { expect(suggested_hire).to validate_presence_of(:suggested_hire_id) }
    it { expect(suggested_hire).to have_attached_file(:resume) }
    it { expect(suggested_hire).to validate_attachment_content_type(:resume).allowing('text/plain', 'application/pdf') }
  end

  describe '#resume_extension' do
    it "returns '' " do
      suggested_hire = create(:suggested_hire, suggested_hire_id: create(:user).id)
      expect(suggested_hire.resume_extension).to eq('')
    end
  end
end

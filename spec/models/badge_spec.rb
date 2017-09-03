require 'rails_helper'

RSpec.describe Badge, type: :model do
  describe 'when validating' do
    let(:badge) { build_stubbed(:badge) }

    it { expect(badge).to validate_presence_of(:label) }
    it { expect(badge).to validate_numericality_of(:points).is_greater_than_or_equal_to(0).only_integer }
    it { expect(badge).to validate_presence_of(:points) }
    it { expect(badge).to validate_presence_of(:enterprise) }
    it { expect(badge).to have_attached_file(:image) }
    it { expect(badge).to validate_attachment_presence(:image) }
    it {
      expect(badge).to validate_attachment_content_type(:image).
        allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml')
    }
    it { expect(badge).to belong_to(:enterprise) }
  end
end

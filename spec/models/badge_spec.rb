require 'rails_helper'

RSpec.describe Badge, type: :model do
  describe 'when validating' do
    let(:badge) { build(:badge) }

    it { expect(badge).to validate_presence_of(:label) }
    it { expect(badge).to validate_numericality_of(:points).is_greater_than_or_equal_to(0).only_integer }
    it { expect(badge).to validate_presence_of(:points) }
    it { expect(badge).to validate_presence_of(:enterprise) }

    # ActiveStorage
    it { expect(badge).to have_attached_file(:image) }
    it { expect(badge).to validate_attachment_presence(:image) }
    it { expect(badge).to validate_attachment_content_type(:image, AttachmentHelper.common_image_types) }

    it { expect(badge).to belong_to(:enterprise) }

    it 'is valid' do
      expect(badge).to be_valid
    end

    it 'requires a label' do
      badge.label = nil
      expect(badge).to_not be_valid
      expect(badge.errors.full_messages.first).to eq("Label can't be blank")
    end

    it 'requires a points' do
      badge.points = nil
      expect(badge).to_not be_valid
      expect(badge.errors.full_messages.first).to eq('Points is not a number')
    end

    it 'requires an Enterprise' do
      badge.enterprise = nil
      expect(badge).to_not be_valid
      expect(badge.errors.full_messages.first).to eq("Enterprise can't be blank")
    end
  end
end

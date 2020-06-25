require 'rails_helper'

RSpec.describe Sponsor, type: :model do
  describe 'association and validations' do
    let(:sponsor) { build_stubbed(:sponsor) }

    it { expect(sponsor).to belong_to(:sponsorable).polymorphic(true) }

    it { expect(sponsor).to validate_length_of(:sponsorable_type).is_at_most(191) }
    it { expect(sponsor).to validate_length_of(:sponsor_message).is_at_most(65535) }
    it { expect(sponsor).to validate_length_of(:sponsor_title).is_at_most(191) }
    it { expect(sponsor).to validate_length_of(:sponsor_name).is_at_most(191) }

    # ActiveStorage
    it { expect(sponsor).to have_attached_file(:sponsor_media) }
    it { expect(sponsor).to validate_attachment_content_type(:sponsor_media, AttachmentHelper.common_image_types) }
  end

  describe 'test scope' do
    describe '.group_sponsor' do
      let!(:group_sponsor) { create(:sponsor, sponsorable_type: 'Group') }

      it 'returns group sponsor' do
        expect(Sponsor.group_sponsor).to eq([group_sponsor])
      end
    end

    describe '.enterprise_sponsor' do
      describe '.enterprise_sponsor' do
        let!(:enterprise_sponsor) { create(:sponsor, sponsorable_type: 'Enterprise') }

        it 'returns group sponsor' do
          expect(Sponsor.enterprise_sponsor).to eq([enterprise_sponsor])
        end
      end
    end
  end
  describe '#sponsor_media_location' do
    it 'returns the actual sponsor_media location' do
      sponsor = create(:sponsor, sponsor_media: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })

      expect(sponsor.sponsor_media_location).to_not be nil
    end
  end

  describe '#sponsorable' do
    it 'correctly returns group and not enterprise' do
      group = create(:group)
      sponsor = create(:sponsor, sponsorable_id: group.id, sponsorable_type: 'Group', sponsor_media: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })

      expect(sponsor.group).to_not be nil
      expect(sponsor.enterprise).to be nil
    end

    it 'correctly returns enterprise and not group' do
      enterprise = create(:enterprise)
      sponsor = create(:sponsor, sponsorable_id: enterprise.id, sponsorable_type: 'Enterprise', sponsor_media: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })

      expect(sponsor.group).to be nil
      expect(sponsor.enterprise).to_not be nil
    end
  end
end

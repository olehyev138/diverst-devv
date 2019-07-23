require 'rails_helper'

RSpec.describe Sponsor, type: :model do
  describe 'validations' do
    let(:sponsor) { build_stubbed(:sponsor) }

    it { expect(sponsor).to have_attached_file(:sponsor_media) }
  end

  describe '#sponsor_media_location' do
    it 'returns the actual sponsor_media location' do
      sponsor = create(:sponsor, sponsor_media: File.new('spec/fixtures/files/verizon_logo.png'))

      expect(sponsor.sponsor_media_location).to_not be nil
      expect(sponsor.sponsor_media_location).to_not eq '/assets/missing.png'
    end
  end

  describe '#sponsorable' do
    it 'correctly returns group and not enterprise' do
      group = create(:group)
      sponsor = create(:sponsor, sponsorable_id: group.id, sponsorable_type: 'Group', sponsor_media: File.new('spec/fixtures/files/verizon_logo.png'))

      expect(sponsor.group).to_not be nil
      expect(sponsor.enterprise).to be nil
    end

    it 'correctly returns enterprise and not group' do
      enterprise = create(:enterprise)
      sponsor = create(:sponsor, sponsorable_id: enterprise.id, sponsorable_type: 'Enterprise', sponsor_media: File.new('spec/fixtures/files/verizon_logo.png'))

      expect(sponsor.group).to be nil
      expect(sponsor.enterprise).to_not be nil
    end
  end
end

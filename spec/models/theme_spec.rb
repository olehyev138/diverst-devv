require 'rails_helper'

RSpec.describe Theme, type: :model do
  let(:theme) { build :theme }

  describe 'test association and validations' do
    it { expect(theme).to have_one(:enterprise) }

    # ActiveStorage
    it { expect(theme).to have_attached_file(:logo) }
    it { expect(theme).to validate_attachment_content_type(:logo, AttachmentHelper.common_image_types) }

    it { expect(theme).to validate_presence_of(:primary_color).with_message('should be a valid hex color') }
    [:primary_color, :secondary_color].each do |color|
      it { expect(theme).to allow_value('FFFFFF').for(color) }
      it { expect(theme).to_not allow_value('red').for(color) }
    end

    it { expect(theme).to validate_length_of(:logo_redirect_url).is_at_most(191) }
    it { expect(theme).to validate_length_of(:secondary_color).is_at_most(191) }
    it { expect(theme).to validate_length_of(:digest).is_at_most(191) }
    it { expect(theme).to validate_length_of(:primary_color).is_at_most(191) }
  end

  describe 'validation' do
    describe 'color validation' do
      describe 'primary color' do
        it 'is invalid with incorrect color' do
          theme.primary_color = 'zz1122'
          expect(theme).to be_invalid
        end

        it 'is valid with correct color' do
          theme.primary_color = 'f15e58'
          expect(theme).to be_valid
        end
      end

      describe 'secondary color' do
        it 'is valid without secondary color' do
          theme.secondary_color = nil
          expect(theme).to be_valid
        end

        it 'is invalid with incorrect color' do
          theme.secondary_color = 'zz1122'
          expect(theme).to be_invalid
        end

        it 'is valid with correct color' do
          theme.secondary_color = 'f15e58'
          expect(theme).to be_valid
        end
      end
    end
  end

  describe '#charts_color' do
    context 'with use_secondary_color=true' do
      before { theme.use_secondary_color = true }

      context 'with both secondary and primary colors' do
        it 'is equal to secondary_color' do
          expect(theme.charts_color).to eq theme.secondary_color
        end
      end

      context 'with primary color only' do
        before { theme.secondary_color = nil }

        it 'is queal to primary color' do
          expect(theme.charts_color).to eq theme.primary_color
        end
      end
    end

    context 'with use_secondary_color=false' do
      before { theme.use_secondary_color = false }

      context 'with both secondary and primary colors' do
        it 'is queal to primary color' do
          expect(theme.charts_color).to eq theme.primary_color
        end
      end

      context 'with primary color only' do
        before { theme.secondary_color = nil }

        it 'is queal to primary color' do
          expect(theme.charts_color).to eq theme.primary_color
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Reward do
  describe 'when validating' do
    let(:reward) { build(:reward) }

    it { expect(reward).to validate_presence_of(:enterprise) }
    it { expect(reward).to validate_numericality_of(:points).is_greater_than_or_equal_to(0).only_integer }
    it { expect(reward).to validate_presence_of(:points) }
    it { expect(reward).to validate_presence_of(:label) }
    it { expect(reward).to validate_presence_of(:responsible) }

    it { expect(reward).to belong_to(:enterprise) }
    it { expect(reward).to belong_to(:responsible).class_name('User').with_foreign_key('responsible_id') }

    # ActiveStorage
    it { expect(reward).to have_attached_file(:picture) }
    it { expect(reward).to validate_attachment_content_type(:picture, AttachmentHelper.common_image_types) }

    context '#responsible_user' do
      context 'when user enterprise and reward enterprise are not the same' do
        let(:user) { create(:user) }
        let(:reward) { build(:reward) }

        it 'reward is invalid' do
          reward.responsible = user
          reward.valid?

          expect(reward.errors.messages).to have_key(:responsible_id)
        end
      end

      context 'when user enterprise and reward enterprise are the same' do
        let(:enterprise) { create(:enterprise) }
        let(:user) { create(:user, enterprise: enterprise) }
        let(:reward) { build(:reward, enterprise: enterprise, responsible: user) }

        it 'reward is valid' do
          expect(reward).to be_valid
        end
      end
    end
  end
end

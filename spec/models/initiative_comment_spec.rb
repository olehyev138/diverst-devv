require 'rails_helper'

RSpec.describe InitiativeComment, type: :model do
  describe 'when validating' do
    let(:initiative_comment) { build_stubbed(:initiative_comment) }

    it { expect(initiative_comment).to belong_to(:user) }
    it { expect(initiative_comment).to belong_to(:initiative) }

    it { expect(initiative_comment).to have_many(:user_reward_actions) }

    it { expect(initiative_comment).to validate_presence_of(:user) }
    it { expect(initiative_comment).to validate_presence_of(:initiative) }
    it { expect(initiative_comment).to validate_presence_of(:content) }
    it { expect(initiative_comment).to validate_length_of(:content).is_at_most(65535) }
  end

  describe 'test instance and class methods' do
    context '#group' do
      let!(:group) { create(:group) }
      let!(:initiative) { create(:initiative, owner_group: group) }
      let!(:initiative_comment) { create(:initiative_comment, initiative_id: initiative.id) }

      it 'returns group belonging to initiative' do
        expect(initiative_comment.group).to eq group
      end
    end

    context '#disapproved?' do
      let!(:initiative_comment) { build(:initiative_comment, approved: false) }

      it 'returns approved initiative comment' do
        expect(initiative_comment.disapproved?).to eq true
      end
    end

    context '.approved' do
      let!(:initiative_comments) { build_list(:initiative_comment, 3, approved: true) }

      it 'returns 3 approved initiative_comments' do
        expect(initiative_comments.count).to eq 3
      end
    end
  end
end

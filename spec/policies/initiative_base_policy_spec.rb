require 'rails_helper'

RSpec.describe InitiativeBasePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:user_group) { create(:user_group, user: user, group: group) }
  let(:initiative) { create(:initiative) }
  let(:initiative_user) { create(:initiative_user, initiative: initiative, user: user) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }

  subject { described_class.new(user.reload, [initiative]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context '#is_creator?' do
        context 'when user is the creator' do
          before { initiative.owner_id = user.id }

          it 'returns true' do
            expect(subject.is_creator?).to eq true
          end
        end
      end

      context '#is_attending?' do
        context 'when user is attending' do
          before do
            create(:initiative_user, initiative: initiative, user: user)
          end
          it 'returns true' do
            expect(subject.is_attending?).to eq true
          end
        end
      end
    end
  end
end

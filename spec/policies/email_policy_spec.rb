require 'rails_helper'

RSpec.describe EmailPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }

  subject { EmailPolicy.new(user.reload, enterprise, Email) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'returns true for #index?' do
        expect(subject.manage?).to eq true
      end

      it 'returns true for #show?' do
        p user.policy_group
        expect(subject.show?).to eq true
      end

      it 'returns true for #update?' do
        p user.policy_group
        expect(subject.update?).to eq true
      end
    end
  end

  describe 'for users without access' do
    describe 'for users with no access' do
      it { is_expected.to forbid_actions([:create, :destroy]) }
    end
  end
end

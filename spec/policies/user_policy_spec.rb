require 'rails_helper'

RSpec.describe UserPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:policy_scope) { UserPolicy::Scope.new(user, User).resolve }

  # subject { described_class }
  subject { UserPolicy.new(user, other_user) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  permissions ".scope" do
    it "shows only users belonging to enterprise" do
      expect(policy_scope).to eq [user]
    end
  end

  describe 'for users with access' do 
    let!(:other_user) { create(:user, enterprise: enterprise) }
    
    context 'when users_index is true but users_manage is false' do
      before { user.policy_group.update(users_index: true, users_manage: false, manage_all: false) }

      it { is_expected.to permit_actions([:index, :show]) }
    end

    context 'when users_index is  false but users_manage is true' do 
      before { user.policy_group.update(users_index: false, users_manage: true, manage_all: false) }

      it { is_expected.to permit_actions([:update, :destroy, :create, :resend_invitation]) }
    end

    context 'when users_index, users_manage, manage_all are false but record is the same as current user' do 
      before do
        user.policy_group.update(users_index: false, users_manage: false, manage_all: false) 
      end

      let!(:other_user) { user }

      it { is_expected.to permit_action(:update) }
    end
  end

  describe 'for users with no access' do 
    before do 
      user.policy_group = create(:policy_group, :no_permissions)
    end

    let!(:other_user) { create(:user, enterprise: enterprise) }
    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy, :resend_invitation]) } 
  end
end

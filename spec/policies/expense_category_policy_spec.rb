require 'rails_helper'

RSpec.describe ExpenseCategoryPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:expense_category) { create(:expense_category) }

  subject { ExpenseCategoryPolicy.new(user, expense_category) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.campaigns_manage = false
    no_access.policy_group.save!

    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  describe 'for users with access' do 
    context 'when manage_all is false' do 
      it "ensure manage_all is false" do
        expect(user.policy_group.manage_all).to be(false)
      end

      context 'allows access to all actions' do 
        it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
      end  

      context 'when subject campaigns_index is false but campaigns_manage is true for user' do 
        before { user.policy_group.update campaigns_index: false }
        it { is_expected.to permit_action :index }
      end

      context 'when subject campaigns_create is false but campaigns_manage is true' do 
        before { user.policy_group.update campaigns_create: false }
        it { is_expected.to permit_actions([:new, :create]) }
      end

      context 'when subject campaigns_manage is true for user' do 
        it { is_expected.to permit_actions([:update, :destroy]) }
      end
    end

    context'when manage_all is true' do
      before {
        user.policy_group.manage_all = true
        user.policy_group.save!
      }

      it 'ensure manage_all is true' do
        expect(user.policy_group.manage_all).to be(true)
      end

      context 'when subject campaigns_index is false but campaigns_manage is true for user' do 
        before { user.policy_group.update campaigns_index: false }
        it { is_expected.to permit_action :index }
      end

      context 'when subject campaigns_create is false but campaigns_manage is true' do 
        before { user.policy_group.update campaigns_create: false }
        it { is_expected.to permit_actions([:new, :create]) }
      end

      context 'when subject campaigns_manage is true for user' do 
        it { is_expected.to permit_actions([:update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }

    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
  end
end

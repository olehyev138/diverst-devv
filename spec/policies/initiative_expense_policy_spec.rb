require 'rails_helper'

RSpec.describe InitiativeExpensePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:initiative_expense){ create(:initiative_expense, owner: user) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }

  permissions :index?, :create?, :update?, :destroy? do
    it 'allows access to a manager' do
      expect(subject).to permit(user, initiative_expense)
    end

    it 'denies access to a user without correct permissions' do
      expect(subject).to_not permit(no_access, initiative_expense)
    end
  end

  permissions :index?, :update?, :destroy? do
    it 'allows access to a normal user' do
      user.policy_group.initiatives_manage = false
      expect(subject).to permit(user, initiative_expense)
    end
  end

  ## TODO Test Scope ##

end

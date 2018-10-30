require 'rails_helper'

RSpec.describe InitiativeUpdatePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:initiative_update){ create(:initiative_update, owner: user) }

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
    it 'allows access to a user with correct permissions' do
      expect(subject).to permit(user, initiative_update)
    end

    it 'denies access to a user without correct permissions' do
      expect(subject).to_not permit(no_access, initiative_update)
    end
  end

  permissions :update?, :destroy? do
    it 'allows normal users to update & destroy' do
      user.policy_group.initiatives_manage = false

      expect(subject).to permit(user, initiative_update)
    end
  end

  ## TODO Test Scope ##

end

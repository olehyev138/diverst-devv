require "rails_helper"

RSpec.describe LogPolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.logs_view = false
    no_access.policy_group.save!
  }

  permissions :index? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, nil)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, nil)
    end
  end
end

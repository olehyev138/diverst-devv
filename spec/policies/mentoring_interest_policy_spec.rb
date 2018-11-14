require 'rails_helper'

RSpec.describe MentoringInterestPolicy, :type => :policy do
  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:mentoring_interest){ create(:mentoring_interest) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.mentorship_manage = false
    no_access.policy_group.save!
  }

  permissions :index? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, mentoring_interest)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, mentoring_interest)
    end
  end
end

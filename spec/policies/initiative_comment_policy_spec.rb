require 'rails_helper'

RSpec.describe InitiativeCommentPolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:initiative_comment){ create(:initiative_comment) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  permissions :erg_leader?, :approve?, :disapprove?, :destroy? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, initiative_comment)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, initiative_comment)
    end
  end

end

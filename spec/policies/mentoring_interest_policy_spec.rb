require 'rails_helper'

RSpec.describe MentoringInterestPolicy, :type => :policy do
  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:mentoring_interest){ create(:mentoring_interest) }

  subject { MentoringInterestPolicy.new(user, mentoring_interest) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.mentorship_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do 
    it { is_expected.to permit_actions([:index, :edit, :create, :update, :destroy]) }
  end  

  describe 'for users with no access' do  
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :edit, :create, :update, :destroy]) }
  end
end

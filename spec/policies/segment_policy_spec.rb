require 'rails_helper'

RSpec.describe SegmentPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:enterprise_2) {create(:enterprise, :scope_module_enabled => false)}
  let(:no_access) { create(:user, :enterprise => enterprise_2) }
  let(:segment){ create(:segment, enterprise: enterprise) }
  let(:segments){ create_list(:segment, 10, enterprise: enterprise2) }
  let(:policy_scope) { SegmentPolicy::Scope.new(user, Segment).resolve }

  subject { SegmentPolicy.new(user, segment) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.segments_index = false
    no_access.policy_group.segments_create = false
    no_access.policy_group.segments_manage = false
    no_access.policy_group.save!
  }

  permissions ".scope" do
    it "shows only segments belonging to enterprise" do
      expect(policy_scope).to eq [segment]
    end
  end

  describe 'for users with access' do 
    context 'with correct permissions' do 
      it { is_expected.to permit_actions([:index, :create, :update, :destroy, :enterprise_segments]) }
    end

    context 'who are non managers' do 
      before { user.policy_group.update segments_manage: false }
      it { is_expected.to permit_actions([:index, :create, :enterprise_segments]) }
    end

    context 'when manage_all is true' do 
      before { user.policy_group.update segments_index: false, segments_manage: false, segments_create: false, manage_all: true }
      it { is_expected.to permit_actions([:index, :create, :update, :destroy, :enterprise_segments]) }
    end

  end

  describe 'for users with no access' do 
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :create, :update, :destroy, :enterprise_segments]) }
  end
end

require 'rails_helper'

RSpec.describe CampaignPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:campaign){ create(:campaign, :enterprise => enterprise)}
  let(:segments){ create_list(:segment, 10, enterprise: enterprise2) }
  let(:policy_scope) { CampaignPolicy::Scope.new(user, Campaign).resolve }

  subject { CampaignPolicy.new(user, campaign) }

  permissions '.scope' do 
    it "shows only campaigns belonging to enterprise" do
      expect(policy_scope).to eq [campaign]
    end
  end

  describe 'for users with access' do 
    context 'when manage_all is false' do 
      before { user.policy_group.update manage_all: false }
      
      it "ensure manage_all is false" do
        expect(user.policy_group.manage_all).to be(false)
      end


      context 'when subject campaigns_index is false but campaigns_manage is true for user' do 
        before { user.policy_group.update campaigns_index: false }
        it { is_expected.to permit_action :index }
      end

      context 'when subject campaigns_create is false but campaigns_manage is true' do 
        before { user.policy_group.update campaigns_create: false }
        it { is_expected.to permit_actions([:new, :create]) }
      end

      it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
    end

    context 'when manage_all is true' do 
      before {
        user.policy_group.manage_all = true
        user.policy_group.campaigns_index = false
        user.policy_group.campaigns_create = false
        user.policy_group.campaigns_manage = false
        user.policy_group.save!
      }

      it "ensure manage_all is true" do
        expect(user.policy_group.manage_all).to be(true)
      end

      it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
    end

    context 'when subject campaigns_index is true for user' do 
      before { user.policy_group.update campaigns_index: false }
      it { is_expected.to permit_action :index }      
    end

    context 'when subject campaigns_create is false but campaigns_manage is true' do 
      before { user.policy_group.update campaigns_create: false }
      it { is_expected.to permit_actions([:new, :create]) }
    end
  end

  describe 'for users with no access' do  
    before do
      no_access.policy_group.manage_all = false
      no_access.policy_group.campaigns_index = false
      no_access.policy_group.campaigns_manage = false
      no_access.policy_group.campaigns_create = false
      no_access.policy_group.save!
    end

    let(:user) { no_access }   

    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) } 
  end  
end

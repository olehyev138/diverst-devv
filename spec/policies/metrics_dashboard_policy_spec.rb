require 'rails_helper'

RSpec.describe MetricsDashboardPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:metrics_dashboard){ create(:metrics_dashboard, :owner_id => user.id, :enterprise => enterprise)}
  let(:metrics_dashboards){ create_list(:metrics_dashboards, 10, enterprise: enterprise2) }
  let(:policy_scope) { MetricsDashboardPolicy::Scope.new(user, MetricsDashboard).resolve }

  subject { MetricsDashboardPolicy.new(user, metrics_dashboard) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.metrics_dashboards_index = false
    no_access.policy_group.metrics_dashboards_create = false
    no_access.policy_group.save!

    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  permissions ".scope" do
    it "shows only metrics_dashboards belonging to enterprise" do
      expect(policy_scope).to eq [metrics_dashboard]
    end
  end

  describe 'for users with access' do 
    describe 'when manage_all is false' do 
      it { is_expected.to permit_actions([:index, :show, :edit, :new, :create, :update, :destroy]) }
      
      context 'when metrics_dashboards_index is true and metrics_dashboards_create is false' do 
        before { user.policy_group.update metrics_dashboards_index: true, metrics_dashboards_create: false }
        it { is_expected.to permit_actions([:index, :show, :edit, :update, :destroy]) }
      end

      context 'when metrics_dashboards_index is true and metrics_dashboards_create is false, and current user IS NOT owner' do 
        before do 
          metrics_dashboard.owner = create(:user)
          user.policy_group.update metrics_dashboards_index: true, metrics_dashboards_create: false
        end

        it { is_expected.to permit_action(:index) }
      end

      context 'when metrics_dashboards_index and metrics_dashboards_create are false, and #is_user_shared?(user) returns true but current user IS NOT owner' do 
        before do 
          metrics_dashboard.owner = create(:user)
          create(:shared_metrics_dashboard, user_id: user.id, metrics_dashboard_id: metrics_dashboard.id)
          user.policy_group.update metrics_dashboards_index: false, metrics_dashboards_create: false
        end

        it { is_expected.to permit_actions([:show, :destroy]) }
      end

      context 'when metrics_dashboards_index and metrics_dashboards_create are false, and #is_user_shared?(user) returns false but current user IS owner' do
        before { user.policy_group.update metrics_dashboards_index: false, metrics_dashboards_create: false }
        it { is_expected.to permit_actions([:show, :update, :edit, :update]) }
      end

      context 'when metrics_dashboards_create is true and metrics_dashboards_index is false and current user IS NOT owner' do 
        before do 
          metrics_dashboard.owner = create(:user)
          user.policy_group.update metrics_dashboards_create: true, metrics_dashboards_index: false
        end

        it { is_expected.to permit_actions([:index, :new]) }
      end
    end

    describe 'when manage_all is true' do 
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :show, :new, :edit, :update, :destroy]) }

      context 'when metrics_dashboards_index is false and metrics_dashboards_create is false and current user IS NOT owner' do 
        before do 
          metrics_dashboard.owner = create(:user)
          user.policy_group.update metrics_dashboards_index: false, metrics_dashboards_create: false
        end

        it { is_expected.to permit_actions([:index, :create, :new, :edit, :update, :destroy]) }
      end
    end
  end  

  describe 'for users with no access' do 
    before { metrics_dashboard.owner = create(:user) }
    let!(:user) { no_access }

    it { is_expected.to forbid_actions([:index, :create, :new, :edit, :update, :destroy]) }
  end
end

require 'rails_helper'

RSpec.describe MetricsDashboardPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:metrics_dashboard) { create(:metrics_dashboard, owner_id: user.id, enterprise: enterprise) }
  let(:metrics_dashboards) { create_list(:metrics_dashboards, 10, enterprise: enterprise2) }
  let(:policy_scope) { MetricsDashboardPolicy::Scope.new(user, MetricsDashboard).resolve }

  subject { MetricsDashboardPolicy.new(user, metrics_dashboard) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.metrics_dashboards_index = false
    no_access.policy_group.metrics_dashboards_create = false
    no_access.policy_group.save!
  }

  permissions '.scope' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'shows only metrics_dashboards belonging to enterprise' do
        expect(policy_scope).to eq [metrics_dashboard]
      end
    end
  end

  describe 'for users with access' do
    describe 'when manage_all is false' do
      context 'when current user IS NOT author' do
        before { metrics_dashboard.owner = create(:user) }

        context 'when metrics_dashboards_index is true' do
          before { user.policy_group.update metrics_dashboards_index: true }
          it { is_expected.to permit_action(:index) }
        end


        context 'when metrics_dashboards_index is true' do
          before { user.policy_group.update metrics_dashboards_create: true }
          it { is_expected.to permit_actions([:index, :new, :create]) }
        end
      end

      context 'when current user IS owner' do
        it { is_expected.to permit_actions([:edit, :show, :update, :destroy]) }
      end

      context 'when metrics_dashboard has shared_user, current user IS NOT owner' do
        before do
          metrics_dashboard.owner = create(:user)
          create(:shared_metrics_dashboard, user_id: user.id, metrics_dashboard_id: metrics_dashboard.id)
        end
        it { is_expected.to permit_actions([:show, :destroy]) }
      end
    end

    describe 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when current user IS NOT owner' do
        before { metrics_dashboard.owner = create(:user) }
        it { is_expected.to permit_actions([:index, :show, :edit, :new, :create, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do
    before { metrics_dashboard.owner = create(:user) }
    it { is_expected.to forbid_actions([:index, :show, :create, :new, :edit, :update, :destroy]) }
  end
end

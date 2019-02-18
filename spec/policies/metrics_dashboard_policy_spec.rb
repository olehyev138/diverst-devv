require 'rails_helper'

RSpec.describe MetricsDashboardPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:metrics_dashboard){ create(:metrics_dashboard, :owner_id => user.id, :enterprise => enterprise)}
  let(:metrics_dashboards){ create_list(:metrics_dashboards, 10, enterprise: enterprise2) }
  let(:policy_scope) { MetricsDashboardPolicy::Scope.new(user, MetricsDashboard).resolve }

  subject { described_class }

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

  context "when manage_all is false" do
    it "ensure manage_all is false" do
      expect(user.policy_group.manage_all).to be(false)
    end

    permissions :index? do
      context "when subject metrics_dashboards_index is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end

      context "when subject metrics_dashboards_index is false but metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do

          user.policy_group.campaigns_index = false
          user.policy_group.save!

          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :show? do
      context "when subject metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end

      context "when subject metrics_dashboards_create is false but metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do

          user.policy_group.metrics_dashboards_create = false
          user.policy_group.save!

          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :edit? do
      context "when subject metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end

      context "when subject metrics_dashboards_create is false but metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do

          user.policy_group.metrics_dashboards_create = false
          user.policy_group.save!

          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :new? do
      context "when subject metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end

      context "when subject metrics_dashboards_create is false for user and false for no_access" do
        it "allows access" do

          user.policy_group.metrics_dashboards_create = false
          user.policy_group.save!

          expect(subject).to_not permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :create? do
      context "when subject metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end

      context "when subject metrics_dashboards_create is false for user and false for no_access" do
        it "allows access" do

          user.policy_group.metrics_dashboards_create = false
          user.policy_group.save!

          expect(subject).to_not permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :update? do
      context "when subject metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :destroy? do
      context "when subject metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end
  end

  context "when manage_all is true" do
    before {
      user.policy_group.manage_all = true
      user.policy_group.metrics_dashboards_index = false
      user.policy_group.metrics_dashboards_create = false
      user.policy_group.save!
      metrics_dashboard.owner_id = nil
      metrics_dashboard.save!
    }
    it "ensure manage_all is true" do
      expect(user.policy_group.manage_all).to be(true)
    end

    permissions :index? do
      context "when subject metrics_dashboards_index is false for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :new? do
      context "when subject metrics_dashboards_create is false for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :create? do
      context "when subject metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :update? do
      context "when subject metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end

    permissions :destroy? do
      context "when subject metrics_dashboards_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, metrics_dashboard)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, metrics_dashboard)
        end
      end
    end
  end
end

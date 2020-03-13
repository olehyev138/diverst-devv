require 'rails_helper'

RSpec.describe MetricsDashboard, type: :model do
  subject { build(:metrics_dashboard) }

  describe 'test associations' do
    it { expect(subject).to belong_to(:enterprise).inverse_of(:metrics_dashboards) }
    it { expect(subject).to belong_to(:owner).class_name('User') }
    it { expect(subject).to have_many(:graphs).dependent(:destroy) }
    it { expect(subject).to have_many(:metrics_dashboards_segments).dependent(:destroy) }
    it { expect(subject).to have_many(:segments).through(:metrics_dashboards_segments) }
    it { expect(subject).to have_many(:groups_metrics_dashboards).dependent(:destroy) }
    it { expect(subject).to have_many(:groups).through(:groups_metrics_dashboards) }
    it { expect(subject).to have_many(:shared_metrics_dashboards).dependent(:destroy) }
    it { expect(subject).to have_many(:shared_users).through(:shared_metrics_dashboards).source(:user) }
  end

  describe 'validations' do
    it { expect(subject).to validate_presence_of(:name).with_message('Metrics Dashboard name is required') }
    it { expect(subject).to validate_presence_of(:groups).with_message('Please select a group') }
    it { expect(subject).to validate_length_of(:shareable_token).is_at_most(191) }
    it { expect(subject).to validate_length_of(:name).is_at_most(191) }
  end

  describe '.with_shared_dashboards' do
    context 'with metrics_dashboard' do
      let!(:user) { create(:user) }
      let!(:metrics_dashboard) { create(:metrics_dashboard, enterprise_id: user.enterprise.id, owner_id: user.id) }

      it 'returns metrics_dashboard' do
        expect(MetricsDashboard.with_shared_dashboards(user.id)).to eq([metrics_dashboard])
      end
    end
  end

  describe '#percentage_of_total' do
    it 'returns 0 when there are no users' do
      allow(subject.enterprise).to receive(:users).and_return(double(size: 0))
      allow(subject).to receive(:target).and_return(double(count: 150))

      expect(subject.percentage_of_total).to eq 0
    end

    it 'returns the rounded percentage of user population in the dashboard' do
      allow(subject.enterprise).to receive(:users).and_return(double(size: 240))
      allow(subject).to receive(:target).and_return(double(count: 100))

      expect(subject.percentage_of_total).to eq 42
    end

    it 'returns 100 if, for some reason, there are more users in the dashboard than the company' do
      allow(subject.enterprise).to receive(:users).and_return(double(size: 240))
      allow(subject).to receive(:target).and_return(double(count: 240))

      expect(subject.percentage_of_total).to eq 100
    end
  end

  describe '#target' do
    it 'returns all users if no segments or groups are specified' do
      expect(subject.target.all).to eq subject.enterprise.users.all
    end

    it 'calls target' do
      expect(subject.graphs_population.all).to eq subject.enterprise.users.all
    end
  end

  describe '#graphable_fields' do
    let(:enterprise) { create(:enterprise) }
    let(:admin) { create(:user, enterprise: enterprise) }

    it 'returns graphable fields' do
      expect(subject.graphable_fields(admin)).to eq(enterprise.fields)
    end
  end

  describe '#shareable_token' do
    let!(:metrics_dashboard) { create :metrics_dashboard }

    context 'with no shareable_token' do
      it 'has nil token' do
        expect(metrics_dashboard.shareable_token).to be(nil)
      end

      it 'creates new shareable token' do
        expect(metrics_dashboard.update_shareable_token).to be(true)
      end

      it 'returns false' do
        metrics_dashboard.groups.destroy_all
        expect(metrics_dashboard.update_shareable_token).to be(false)
      end
    end

    context 'with existing shareable_token' do
      let(:token) { Faker::Crypto.md5 }
      before { metrics_dashboard.update(shareable_token: token) }

      it 'does not update it' do
        metrics_dashboard.reload

        expect(metrics_dashboard.shareable_token).to eq token
      end
    end
  end

  describe '#is_user_shared?' do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user, enterprise: user.enterprise) }
    let!(:metrics_dashboard) { create(:metrics_dashboard, owner: user, enterprise: user.enterprise, shared_user_ids: [user2.id]) }

    it 'checks if a user is shared' do
      expect(metrics_dashboard.is_user_shared?(user2)).to eq true
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      metrics_dashboard = create(:metrics_dashboard)
      graph = create(:graph_with_metrics_dashboard, metrics_dashboard: metrics_dashboard)
      segment = create(:metrics_dashboards_segment, metrics_dashboard: metrics_dashboard)
      group = create(:groups_metrics_dashboard, metrics_dashboard: metrics_dashboard)

      metrics_dashboard.destroy

      expect { MetricsDashboard.find(metrics_dashboard.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Graph.find(graph.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { MetricsDashboardsSegment.find(segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { GroupsMetricsDashboard.find(group.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

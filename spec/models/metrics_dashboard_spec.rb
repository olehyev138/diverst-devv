require 'rails_helper'

RSpec.describe MetricsDashboard, :type => :model do
    subject { create(:metrics_dashboard) }

    describe 'test associations' do
      it{ expect(subject).to belong_to(:enterprise).inverse_of(:metrics_dashboards) }
      it{ expect(subject).to belong_to(:owner).class_name('User') }
      it{ expect(subject).to have_many(:graphs) }
      it{ expect(subject).to have_many(:metrics_dashboards_segments) }
      it{ expect(subject).to have_many(:segments).through(:metrics_dashboards_segments) }
      it{ expect(subject).to have_many(:groups_metrics_dashboards) }
      it{ expect(subject).to have_many(:groups).through(:groups_metrics_dashboards) }
    end

    describe 'validations' do
        it{ expect(subject).to validate_presence_of(:name).with_message("Metrics Dashboard name is required") }
        it{ expect(subject).to validate_presence_of(:groups).with_message("Please select a group") }
    end

    describe '#percentage_of_total' do
        it 'returns 0 when there are no users' do
            allow(subject.enterprise).to receive(:users).and_return(double(count: 0))
            allow(subject).to receive(:target).and_return(double(count: 150))

            expect(subject.percentage_of_total).to eq 0
        end

        it 'returns the rounded percentage of user population in the dashboard' do
            allow(subject.enterprise).to receive(:users).and_return(double(count: 240))
            allow(subject).to receive(:target).and_return(double(count: 100))

            expect(subject.percentage_of_total).to eq 42
        end

        it 'returns 100 if, for some reason, there are more users in the dashboard than the company' do
            allow(subject.enterprise).to receive(:users).and_return(double(count: 240))
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
end

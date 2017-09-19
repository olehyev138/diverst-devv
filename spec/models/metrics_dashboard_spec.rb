require 'rails_helper'

RSpec.describe MetricsDashboard, :type => :model do
    subject { create(:metrics_dashboard) }

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
    end
end

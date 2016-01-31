require 'rails_helper'

RSpec.describe MetricsDashboard do
  subject { create(:metrics_dashboard) }

  describe '#percentage_of_total' do
    it 'returns 0 when there are no employees' do
      allow(subject.enterprise).to receive(:employees).and_return(double(count: 0))
      allow(subject).to receive(:target).and_return(double(count: 150))

      expect(subject.percentage_of_total).to eq 0
    end

    it 'returns the rounded percentage of employee population in the dashboard' do
      allow(subject.enterprise).to receive(:employees).and_return(double(count: 240))
      allow(subject).to receive(:target).and_return(double(count: 100))

      expect(subject.percentage_of_total).to eq 42
    end

    it 'returns 100 if, for some reason, there are more employees in the dashboard than the company' do
      allow(subject.enterprise).to receive(:employees).and_return(double(count: 240))
      allow(subject).to receive(:target).and_return(double(count: 240))

      expect(subject.percentage_of_total).to eq 100
    end
  end

  describe '#target' do
    it 'returns all employees if no segments or groups are specified' do
      expect(subject.target.all).to eq subject.enterprise.employees.all
    end
  end

end

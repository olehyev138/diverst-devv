require 'rails_helper'

RSpec.describe SharedMetricsDashboard, type: :model do
  subject { build(:shared_metrics_dashboard) }

  describe 'test associations' do
    it { expect(subject).to belong_to(:metrics_dashboard) }
    it { expect(subject).to belong_to(:user) }
  end

  describe 'validations' do
    it { expect(subject).to validate_presence_of(:user_id) }
    it { expect(subject).to validate_presence_of(:metrics_dashboard_id) }
  end
end

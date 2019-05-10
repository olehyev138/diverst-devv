require 'rails_helper'

RSpec.describe GroupsMetricsDashboard, type: :model do
  let!(:groups_metrics_dashboard) { build_stubbed(:groups_metrics_dashboard) }

  it { expect(groups_metrics_dashboard).to belong_to(:group) }
  it { expect(groups_metrics_dashboard).to belong_to(:metrics_dashboard) }
end

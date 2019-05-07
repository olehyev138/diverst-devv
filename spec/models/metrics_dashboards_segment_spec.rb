require 'rails_helper'

RSpec.describe MetricsDashboardsSegment, type: :model do
  let!(:metrics_dashboards_segment) { build_stubbed(:metrics_dashboards_segment) }

  it { expect(metrics_dashboards_segment).to belong_to(:segment) }
  it { expect(metrics_dashboards_segment).to belong_to(:metrics_dashboard) }
end

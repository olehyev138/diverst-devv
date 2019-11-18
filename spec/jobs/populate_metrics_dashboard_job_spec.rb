require 'rails_helper'

RSpec.describe PopulateMetricsDashboardJob, type: :job do
  let!(:user) { create(:user) }
  let!(:group) { create(:group, enterprise: user.enterprise) }

  it 'creates initiatives and messages for group' do
    # perform the job
    subject.perform({ enterprise_id: user.enterprise_id })

    group.reload

    # check if the initiatives and messages where created
    expect(group.messages.count).to be > 0
    expect(group.initiatives.count).to be > 0
  end
end

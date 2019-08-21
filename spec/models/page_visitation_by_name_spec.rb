require 'rails_helper'

RSpec.describe PageVisitationByName, type: :model do
  let(:page_visitation_by_name) { build_stubbed(:page_visitation_by_name) }

  it { expect(page_visitation_by_name).to belong_to(:user) }
end

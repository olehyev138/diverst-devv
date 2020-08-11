require 'rails_helper'

RSpec.describe BusinessImpact, type: :model do
  let!(:business_impact) { build_stubbed(:business_impact) }

  it { expect(business_impact).to belong_to(:enterprise) }
  it { expect(business_impact).to validate_presence_of(:name) }
end

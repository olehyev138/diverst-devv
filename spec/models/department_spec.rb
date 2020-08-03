require 'rails_helper'

RSpec.describe Department, type: :model do
  let!(:department) { build_stubbed(:department) }

  it { expect(department).to belong_to(:enterprise) }
  it { expect(department).to validate_presence_of(:name) }
end

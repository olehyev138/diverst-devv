require 'rails_helper'

RSpec.describe MobileField, type: :model do
  let!(:mobile_field) { build_stubbed(:mobile_field) }

  it { expect(mobile_field).to belong_to(:field) }
  it { expect(mobile_field).to belong_to(:enterprise) }
end

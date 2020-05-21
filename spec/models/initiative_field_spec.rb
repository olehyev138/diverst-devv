require 'rails_helper'

RSpec.describe InitiativeField, type: :model do
  let!(:initiative_field) { build_stubbed(:initiative_field) }

  it { expect(initiative_field).to belong_to(:initiative) }
  it { expect(initiative_field).to belong_to(:field) }
end

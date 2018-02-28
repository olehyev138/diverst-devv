require 'rails_helper'

RSpec.describe InitiativeUpdate, type: :model do
  let!(:initiative_update) { build(:initiative_update) }

  it { expect(initiative_update).to belong_to(:owner).class_name('User') }
  it { expect(initiative_update).to belong_to(:initiative) }
end
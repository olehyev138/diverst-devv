require 'rails_helper'

RSpec.describe InitiativeGroup, type: :model do
	let!(:initiative_group) { build(:initiative_group) }

	it { expect(initiative_group).to belong_to(:initiative) }
	it { expect(initiative_group).to belong_to(:group) }
end
require 'rails_helper'

RSpec.describe InitiativeParticipatingGroup, type: :model do
  let!(:initiative_participating_group) { build_stubbed(:initiative_participating_group) }

  it { expect(initiative_participating_group).to belong_to(:initiative) }
  it { expect(initiative_participating_group).to belong_to(:group) }
end

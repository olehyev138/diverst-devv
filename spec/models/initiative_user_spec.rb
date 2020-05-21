require 'rails_helper'

RSpec.describe InitiativeUser, type: :model do
  let!(:initiative_user) { build_stubbed(:initiative_user) }

  it { expect(initiative_user).to belong_to(:initiative) }
  it { expect(initiative_user).to belong_to(:user) }
end

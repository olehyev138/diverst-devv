require 'rails_helper'

RSpec.describe InitiativeInvitee, type: :model do
  let!(:initiative_invitee) { build_stubbed(:initiative_invitee) }

  it { expect(initiative_invitee).to belong_to(:user) }
  it { expect(initiative_invitee).to belong_to(:initiative) }
end

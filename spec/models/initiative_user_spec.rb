require 'rails_helper'

RSpec.describe InitiativeUser, type: :model do
  let!(:initiative_user) { build(:initiative_user) }

  it { expect(initiative_user).to belong_to(:initiative) }
  it { expect(initiative_user).to belong_to(:user).counter_cache(:initiatives_count) }

  it { expect(initiative_user).to validate_presence_of(:initiative_id) }
  it { expect(initiative_user).to validate_presence_of(:user_id) }
  it { expect(initiative_user).to validate_uniqueness_of(:user_id).scoped_to(:initiative_id).with_message('has already joined this event') }
end

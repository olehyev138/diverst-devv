require 'rails_helper'

RSpec.describe GroupsPoll, type: :model do
  let!(:groups_poll) { build_stubbed(:groups_poll) }

  it { expect(groups_poll).to belong_to(:group) }
  it { expect(groups_poll).to belong_to(:poll) }
end

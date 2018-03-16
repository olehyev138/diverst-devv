require 'rails_helper'

RSpec.describe GroupLeader, type: :model do

  describe 'when validating' do
    let(:group_leader) { build_stubbed(:group_leader) }

    it{ expect(group_leader).to validate_presence_of(:position_name) }
    it{ expect(group_leader).to validate_presence_of(:group) }
    it{ expect(group_leader).to validate_presence_of(:user) }
    it{ expect(group_leader).to belong_to(:user) }
    it{ expect(group_leader).to belong_to(:group) }
  end
end

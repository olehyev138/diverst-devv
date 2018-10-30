require 'rails_helper'

RSpec.describe GroupLeader, type: :model do

  describe 'when validating' do
    let!(:enterprise) {create(:enterprise)}
    let(:group_leader) { build(:group_leader) }

    it{ expect(group_leader).to validate_presence_of(:position_name) }
    it{ expect(group_leader).to validate_presence_of(:group) }
    it{ expect(group_leader).to validate_presence_of(:user) }
    it{ expect(group_leader).to validate_uniqueness_of(:user_id).with_message('already exists as a group leader').case_insensitive }
    it{ expect(group_leader).to belong_to(:user) }
    it{ expect(group_leader).to belong_to(:group) }
  end

end

require 'rails_helper'

RSpec.describe BasePager, type: :model do
  describe '#pager' do
    it 'returns the users as items and the total' do
      create_list(:user, 10)
      expect(User.index({}, {}).total).to eq(10)
    end

    it 'returns the groups as items and the total for the correct enterprise' do
      enterprise_1 = create(:enterprise)
      enterprise_2 = create(:enterprise)

      create_list(:group, 5,  enterprise_id: enterprise_1.id)
      create_list(:group, 10, enterprise_id: enterprise_2.id)

      expect(Group.index({}, { enterprise_id: enterprise_1.id }).total).to eq(5)
      expect(Group.index({}, { enterprise_id: enterprise_2.id }).total).to eq(10)
    end
  end
end

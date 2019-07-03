require 'rails_helper'

RSpec.describe BasePager, type: :model do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }

  describe '#pager' do
    it 'returns the users as items and the total' do
      create_list(:user, 10, enterprise: enterprise)
      response = User.index(Request.create_request(user), {})
      expect(response.total).to eq(11) # One more because of the initial user
      expect(response.type).to eq('user')
    end
    
    it 'returns the correct by name for the current users enterprise' do
      enterprise_2 = create(:enterprise)
      create_list(:user, 10, enterprise: enterprise)
      user = create(:user, first_name: "jack", enterprise: enterprise)
      user_2 = create(:user, first_name: "jack", enterprise: enterprise_2)
      response = User.index(Request.create_request(user), {search: "jack"})
      expect(response.total).to eq(1)
    end

    it 'returns the groups as items and the total for the correct enterprise' do
      enterprise_2 = create(:enterprise)
      user_2 = create(:user, enterprise: enterprise_2)

      create_list(:group, 5,  enterprise_id: enterprise.id)
      create_list(:group, 10, enterprise_id: enterprise_2.id)

      expect(Group.index(Request.create_request(user), { enterprise_id: enterprise.id }).total).to eq(5)
      expect(Group.index(Request.create_request(user_2), { enterprise_id: enterprise_2.id }).total).to eq(10)
    end
  end
end

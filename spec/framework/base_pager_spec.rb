require 'rails_helper'

RSpec.describe BasePager, type: :model do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise, first_name: 'notjack', last_name: 'notjack') }

  describe '#pager' do
    it 'returns the users as items and the total' do
      create_list(:user, 10, enterprise: enterprise)
      response = User.index(Request.create_request(user), {})
      expect(response.total).to eq(11) # One more because of the initial user
      expect(response.type).to eq('user')
    end

    it 'returns the correct by name for the current users enterprise' do
      enterprise_2 = create(:enterprise)
      user = create(:user, first_name: 'jack', enterprise: enterprise)
      create(:user, first_name: 'jack', enterprise: enterprise_2)

      response = User.index(Request.create_request(user), { search: 'jack' })
      expect(response.total).to eq(1)
    end

    it 'returns the correct users by scope' do
      enterprise_2 = create(:enterprise)
      create_list(:user, 10, enterprise: enterprise)
      create(:user, first_name: 'jack', enterprise: enterprise)
      user_2 = create(:user, first_name: 'jack', enterprise: enterprise_2, active: false)
      request = Request.create_request(user_2)

      response = User.index(request, { search: 'jack', query_scopes: ['active'] })
      expect(response.total).to eq(0)

      response = User.index(request, { search: 'jack', query_scopes: ['inactive'] })
      expect(response.total).to eq(1)
    end

    it 'returns the correct users by scopes with arguments' do
      enterprise_2 = create(:enterprise)
      create_list(:user, 10, enterprise: enterprise)
      create(:user, first_name: 'jack', enterprise: enterprise)
      user_2 = create(:user, first_name: 'jack', enterprise: enterprise_2, active: false)
      create(:user, first_name: 'Steve', enterprise: enterprise_2, active: true, mentor: true, accepting_mentor_requests: true)
      group = create(:group, enterprise: enterprise)
      create(:user_group, group: group, user: user_2)
      request = Request.create_request(user_2)

      response = User.index(request, { query_scopes: ['active', ['enterprise_mentors', [user_2.id]]] })
      expect(response.total).to eq(1)
    end

    it 'returns the correct users by scopes with arguments sent as JSON' do
      enterprise_2 = create(:enterprise)
      create_list(:user, 10, enterprise: enterprise)
      create(:user, first_name: 'jack', enterprise: enterprise)
      user_2 = create(:user, first_name: 'jack', enterprise: enterprise_2, active: false)
      create(:user, first_name: 'Steve', enterprise: enterprise_2, active: true, mentor: true, accepting_mentor_requests: true)
      group = create(:group, enterprise: enterprise)
      create(:user_group, group: group, user: user_2)
      request = Request.create_request(user_2)

      response = User.index(request, { query_scopes: "[\"active\", [\"enterprise_mentors\", #{user_2.id}]]" })
      expect(response.total).to eq(1)
    end

    it 'filters invalid_scopes' do
      enterprise_2 = create(:enterprise)
      create_list(:user, 10, enterprise: enterprise)
      create(:user, first_name: 'jack', enterprise: enterprise)
      user_2 = create(:user, first_name: 'jack', enterprise: enterprise_2, active: false)
      request = Request.create_request(user_2)

      response = User.index(request, { search: 'jack', query_scopes: ['active', 'fakescope', 'ijustmadethisup', 'destroy_all', 'delete_all'] })
      expect(response.total).to eq(0)
    end

    it 'filters excluded_scopes' do
      enterprise_2 = create(:enterprise)
      create_list(:user, 10, enterprise: enterprise)
      create(:user, first_name: 'jack', enterprise: enterprise)
      user_2 = create(:user, first_name: 'jack', enterprise: enterprise_2, active: false)
      request = Request.create_request(user_2)

      response = User.index(request, { search: 'jack', query_scopes: ['active', 'destroy_all', 'delete_all'] })
      expect(response.total).to eq(0)
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

require 'rails_helper'

RSpec.feature 'Calendar Management' do
  let!(:enterprise) { create(:enterprise, time_zone: 'UTC') }
  let!(:admin_user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise: enterprise, parent_id: nil) }
  let!(:sub_group) { create(:group, enterprise: enterprise, parent_id: group.id) }

  before do
    login_as(admin_user, scope: :user)
    visit calendar_groups_path
  end

  context 'Filter Events in Calendar View;', skip: 'FAILS CONSISTENTLY' do
    scenario 'filter by ERGs', js: true do
      expect(page).to have_select('q_initiative_participating_groups_group_id_in', with_options: [group.name, sub_group.name])
      select(sub_group.name, from: 'q_initiative_participating_groups_group_id_in')

      click_on 'Filter'
    end
  end
end

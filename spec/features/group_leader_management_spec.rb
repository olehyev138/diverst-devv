require 'rails_helper'

RSpec.feature 'Group Leader Management' do
  let!(:enterprise) { create(:enterprise, name: 'The Enterprise') }
  let!(:user) { create(:user, enterprise: enterprise, first_name: 'Aaron', last_name: 'Patterson') }
  let!(:other_user) { create(:user, enterprise: enterprise, first_name: 'Yehuda', last_name: 'Katz') }
  let!(:inactive_user) { create(:user, enterprise: enterprise, first_name: 'John', last_name: 'Smith', active: false) }
  let!(:group) { create(:group, name: 'Group ONE', enterprise: enterprise) }

  before do
    login_as(user, scope: :user)
    [user, other_user, inactive_user].each do |user|
      create(:user_group, user_id: user.id, group_id: group.id, accepted_member: 1)
    end
  end

  context 'Manage Group Leaders' do
    before do
      visit group_leaders_path(group)

      within('.content__header h1') do
        expect(page).to have_content 'Group Leaders'
      end
      expect(page).to have_link 'Manage leaders'

      click_on 'Manage leaders'

      within('.content__header h1') do
        expect(page).to have_content 'Add Leaders to Group ONE'
      end
      expect(page).to have_link 'Add a leader'
    end

    scenario 'ensure only active users are listed', js: true do
      click_on 'Add a leader'

      first('.select2-container', minimum: 1).click

      expect { find('li.select2-results__option[role="treeitem"]', text: "John Smith - #{inactive_user.email}") }.to raise_error(Capybara::ElementNotFound)
    end

    scenario 'add a group leader', js: true do
      click_on 'Add a leader'

      first('.select2-container', minimum: 1).click
      find('li.select2-results__option[role="treeitem"]', text: "Aaron Patterson - #{user.email}").click

      fill_in page.find('.custom-position-field')[:id], with: 'Chief Software Architect'

      click_on 'Save Leaders'

      expect(current_path).to eq group_leaders_path(group)
      within('.content__header h1') do
        expect(page).to have_content 'Group Leaders'
      end
      expect(page).to have_link 'Aaron Patterson'
      expect(page).to have_content 'Chief Software Architect'
    end

    scenario 'add multiple group leaders and display them on home page', js: true, skip: 'CANNOT GET THIS TO PASS' do
      click_on 'Add a leader'

      first('.select2-container', minimum: 1).click
      find('li.select2-results__option[role="treeitem"]', text: "Aaron Patterson - #{user.email}").click
      fill_in page.find('.custom-position-field')[:id], with: 'Chief Software Architect'
      page.find('.group-contact-field').click

      click_on 'Add a leader'

      within all('.nested-fields')[1] do
        first('.select2-container', minimum: 1).click
        find('li.select2-results__option[role="treeitem"]', text: "Aaron Patterson - #{user.email}").click
        fill_in page.find('.custom-position-field')[:id], with: 'Senior Software Engineer'
      end

      click_on 'Save Leaders'

      visit group_path(group)

      expect(page).to have_content user.name
      expect(page).to have_content 'Chief Software Architect'
      expect(page).to have_content other_user.name
      expect(page).to have_content 'Senior Software Engineer'
    end

    context 'for existing multiple group leaders' do
      before do
        [user, other_user].each do |user|
          create(:group_leader, group: group, user: user)
        end

        visit group_leaders_path(group)

        expect(page).to have_link user.name
        expect(page).to have_link other_user.name
        click_on 'Manage leaders'
        expect(page).to have_content('Add Leaders') 
      end

      scenario 'remove one group leader from list of group leaders', js: true do
        within all('.nested-fields')[0] do
          select_field = page.find('.custom-user-select select')[:id]
          expect(page).to have_select(select_field, selected: user.name)
          click_link 'Remove'
        end

        click_on 'Save Leaders'

        visit group_leaders_path(group)

        expect(page).to have_no_content 'Aaron Patterson'
        expect(page).to have_content other_user.name
      end

      scenario 'edit one of multiple group leaders', js: true do
        within all('.nested-fields')[1] do
          select other_user.name, from: page.find('.custom-user-select select')[:id]
          fill_in page.find('.custom-position-field')[:id], with: 'Lead Software Engineer'
        end

        click_on 'Save Leaders'

        visit group_leaders_path(group)

        expect(page).to have_no_content 'Senior Software Engineer'
        expect(page).to have_content 'Lead Software Engineer'
      end
    end

    scenario 'set email of displayed group leader as group contact', js: true do
      click_on 'Add a leader'

      first('.select2-container', minimum: 1).click
      find('li.select2-results__option[role="treeitem"]', text: "Aaron Patterson - #{user.email}").click
      fill_in page.find('.custom-position-field')[:id], with: 'Chief Software Architect'
      page.find('.group-contact-field').click

      click_on 'Save Leaders'

      visit group_path(group)

      expect(current_path).to eq group_path(group)
      expect(page).to have_content 'Aaron Patterson'
      expect(page).to have_content 'Chief Software Architect'
      expect(page).to have_button 'Contact Group Leader'
    end

    scenario 'set any other group leader(who is not displayed) as group contact', js: true do
      click_on 'Add a leader'

      first('.select2-container', minimum: 1).click
      find('li.select2-results__option[role="treeitem"]', text: "Yehuda Katz - #{other_user.email}").click
      fill_in page.find('.custom-position-field')[:id], with: 'Chief Software Architect'
      page.find('.show-leader-field').click
      page.find('.group-contact-field').click

      click_on 'Save Leaders'

      visit group_path(group)

      expect(current_path).to eq group_path(group)
      expect(page).to have_no_content other_user.name
      expect(page).to have_button 'Contact Group Leader'
    end
  end
end

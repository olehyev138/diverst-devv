require 'rails_helper'

RSpec.feature 'Survey Management' do
  let!(:enterprise) { create(:enterprise) }
  let!(:admin_user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise_id: enterprise.id) }

  before do
    login_as(admin_user, scope: :user)
  end


  context 'when creating a survey' do
    before do
      visit new_poll_path

      fill_in 'poll[title]', with: 'First Group Survey'
      fill_in 'poll[description]', with: 'Everyone is welcome to fill out this particular survey'
      select group.name, from: 'Choose the Groups you want to target'
    end

    scenario 'add custom text field', js: true do
      click_on 'Add text field'

      fill_in '* Title', with: 'Where do you live?'

      click_on 'Save and publish'

      poll = Poll.find_by(title: 'First Group Survey')
      tf_id = TextField.last.id

      visit new_poll_poll_response_path(poll)

      expect(page).to have_field(id: "where do you live?_#{tf_id}", type: 'text')
    end

    scenario 'add custom text field with multiple lines', js: true do
      click_on 'Add text field'

      fill_in '* Title', with: 'Where do you live?'
      page.find_field('Allow multiple lines').trigger('click')

      click_on 'Save and publish'

      poll = Poll.find_by(title: 'First Group Survey')
      tf_id = TextField.last.id

      visit new_poll_poll_response_path(poll)

      expect(page).to have_field(id: "where do you live?_#{tf_id}", type: 'textarea')
    end

    scenario 'add custom select field', js: true do
      click_on 'Add select field'

      fill_in '* Title', with: 'What programming languages are you proficient in?'
      fill_in 'Options (one per line)', with: "Ruby\nJava\nElixir\nJavaScript"

      click_on 'Save and publish'

      poll = Poll.find_by(title: 'First Group Survey')
      sf_id = SelectField.last.id

      visit new_poll_poll_response_path(poll)

      expect(page).to have_select(id: "what programming languages are you proficient in?_#{sf_id}",
                                  with_options: ['Ruby', 'Java', 'Elixir', 'JavaScript'])
    end

    context 'add' do
      before do
        click_on 'Add checkbox field'

        fill_in '* Title', with: 'What country(ies) is/are your preferred destination?'
        fill_in 'Options (one per line)', with: "Spain\nArgentina\nBrazil\nGermany\nCanada"
      end

      scenario 'custom checkbox field', js: true do
        click_on 'Save and publish'

        poll = Poll.find_by(title: 'First Group Survey')

        visit new_poll_poll_response_path(poll)

        expect(page).to have_content 'What country(ies) is/are your preferred destination?'
        expect(page).to have_unchecked_field('Spain', type: 'checkbox')
        expect(page).to have_unchecked_field('Argentina', type: 'checkbox')
        expect(page).to have_unchecked_field('Brazil', type: 'checkbox')
        expect(page).to have_unchecked_field('Germany', type: 'checkbox')
        expect(page).to have_unchecked_field('Canada', type: 'checkbox')
      end

      scenario 'custom checkbox field with multi-select option', js: true do
        page.find_field('Use multi-select field').trigger('click')

        click_on 'Save and publish'

        poll = Poll.find_by(title: 'First Group Survey')
        cf_id = CheckboxField.last.id
        visit new_poll_poll_response_path(poll)

        expect(page).to have_content 'What country(ies) is/are your preferred destination?'
        expect(page).to have_select(id: "what country(ies) is/are your preferred destination?_#{cf_id}",
                                    with_options: ['Spain', 'Argentina', 'Brazil', 'Germany', 'Canada'])
      end
    end
  end
end

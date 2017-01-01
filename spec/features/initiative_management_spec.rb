require 'rails_helper'

RSpec.feature 'Initiative management' do

  let(:user) { create(:user) }
  let!(:group) { create :group, :with_outcomes, enterprise: user.enterprise }


  before do
    login_as(user, scope: :user)
  end

  scenario 'creating initiative' do
    initiative_params = {
      name:  Faker::Lorem.sentence,
      description:  Faker::Lorem.sentence,
      location: Faker::Address.city,
      estimated_funding: 0,
      start: Faker::Time.between(DateTime.now, 2.days.from_now),
      end: Faker::Time.between(3.days.from_now, 5.days.from_now),
      max_attendees: Faker::Number.between(1, 100),
      picture_path: test_png_image_path
    }

    visit new_group_initiative_path(group)

    fill_in 'initiative_name', with: initiative_params[:name]
    fill_in 'initiative_description', with: initiative_params[:description]
    fill_in 'initiative_location', with: initiative_params[:location]
    fill_date 'initiative_start', initiative_params[:start]
    fill_date 'initiative_end', initiative_params[:end]
    fill_in 'initiative_max_attendees', with: initiative_params[:max_attendees]
    attach_file 'initiative_picture', initiative_params[:picture_path]

    submit_form

    #Expect new Initiative to be created
    expect(page).to have_current_path group_initiatives_path( group )

    expect(page).to have_content initiative_params[:name]

    #Check all the fields of newly created initiative
    visit edit_group_initiative_path(group, Initiative.last)

    expect(page).to have_field('initiative_name', with: initiative_params[:name])
    expect(page).to have_field('initiative_description', with: initiative_params[:description])
    expect(page).to have_field('initiative_location', with: initiative_params[:location])
    check_date 'initiative_start', initiative_params[:start]
    check_date 'initiative_end', initiative_params[:end]

    expect(page).to have_field('initiative_max_attendees', with: initiative_params[:max_attendees])

    #bTODO how to check that we have image?
    #expect(page).to have_field('initiative_picture', with: initiative_params[:picture_path])
  end
end
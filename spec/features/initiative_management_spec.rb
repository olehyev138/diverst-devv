require 'rails_helper'

RSpec.feature 'Initiative management' do

  let(:user) { create(:user) }
  let!(:group) { create :group, :with_outcomes, enterprise: user.enterprise }

  let!(:initiative_params) {
    {
      name:  Faker::Lorem.sentence,
      description:  Faker::Lorem.sentence,
      location: Faker::Address.city,
      estimated_funding: 0,
      start: Faker::Time.between(DateTime.now, 2.days.from_now),
      end: Faker::Time.between(3.days.from_now, 5.days.from_now),
      max_attendees: Faker::Number.between(1, 100),
      picture_path: test_png_image_path
    }
  }

  before do
    create(:user_group, group: group, user: user, accepted_member: true)
    login_as(user, scope: :user)
  end

  context 'without budget' do
    before { visit new_group_initiative_path(group) }

    scenario 'creating initiative without budget' do
      fill_form( initiative_params )

      submit_form

      #Expect new Initiative to be created
      expect(page).to have_current_path group_initiatives_path( group )

      expect(page).to have_content initiative_params[:name]

      check_initiative( initiative_params )
    end
  end

  context 'with budget item' do
    let!(:budget) { create :approved_budget, subject: group }
    let!(:budget_item) { budget.budget_items.first }

    before { visit new_group_initiative_path(group) }

    scenario 'creating initiative with budget' do
      fill_form( initiative_params )

      select(budget_item.title_with_amount, from: 'initiative_budget_item_id')

      submit_form

      #Expect new Initiative to be created
      expect(page).to have_current_path group_initiatives_path( group )

      expect(page).to have_content initiative_params[:name]

      check_initiative( initiative_params )

      #check that budget is allocated
      budget_item.reload
      expect(budget_item.is_done).to eq true
      expect(budget_item.available_amount).to eq 0
      expect(Initiative.last.estimated_funding).to eq budget_item.estimated_amount
    end
  end

  context 'with leftover money' do
    let(:leftover) { rand(100..1000) }

    before do
      group.update(leftover_money: leftover)
      visit new_group_initiative_path(group)
    end

    scenario 'creating initiative with leftover money' do
      fill_form( initiative_params )

      select(group.title_with_leftover_amount, from: 'initiative_budget_item_id')

      submit_form

      #Expect new Initiative to be created
      expect(page).to have_current_path group_initiatives_path( group )

      expect(page).to have_content initiative_params[:name]

      check_initiative( initiative_params )

      #Check that group leftover was decreased
      group.reload
      expect(group.leftover_money).to eq 0

      expect(Initiative.last.estimated_funding).to eq leftover
    end
  end

  def fill_form( initiative_params )
    fill_in 'initiative_name', with: initiative_params[:name]
    fill_in 'initiative_description', with: initiative_params[:description]
    fill_in 'initiative_location', with: initiative_params[:location]
    fill_in 'initiative_start', with: format_date_time(initiative_params[:start])
    fill_in 'initiative_end', with: format_date_time(initiative_params[:end])
    fill_in 'initiative_max_attendees', with: initiative_params[:max_attendees]
    attach_file 'initiative_picture', initiative_params[:picture_path]
  end

  def check_initiative( initiative_params )
    #Check all the fields of newly created initiative
    visit edit_group_initiative_path(group, Initiative.last)

    expect(page).to have_field('initiative_name', with: initiative_params[:name])
    expect(page).to have_field('initiative_description', with: initiative_params[:description])
    expect(page).to have_field('initiative_location', with: initiative_params[:location])
    expect(format_date_time(DateTime.parse(find_field('initiative_start').value)))
      .to eq format_date_time(initiative_params[:start])
    expect(format_date_time(DateTime.parse(find_field('initiative_end').value)))
      .to eq format_date_time(initiative_params[:end])

    expect(page).to have_field('initiative_max_attendees', with: initiative_params[:max_attendees])

    #bTODO how to check that we have image?
    #expect(page).to have_field('initiative_picture', with: initiative_params[:picture_path])

    # Check initiative on employees dashboard
    visit group_events_path(group)
    expect(page).to have_content initiative_params[:name]
  end

  def format_date_time(date_time)
    date_time.strftime("%Y-%m-%d %H:%m")
  end
end

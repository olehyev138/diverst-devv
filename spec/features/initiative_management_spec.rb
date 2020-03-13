require 'rails_helper'

RSpec.feature 'Initiative management' do
  let(:user) { create(:user) }
  let!(:group) { create :group, enterprise: user.enterprise, annual_budget: 10000 }

  let!(:initiative_params) {
    {
      name: Faker::Lorem.sentence,
      description: Faker::Lorem.sentence,
      location: Faker::Address.city,
      estimated_funding: 1000,
      start: Faker::Time.between(2.days.ago, DateTime.yesterday),
      end: Faker::Time.between(3.days.from_now, 5.days.from_now),
      max_attendees: Faker::Number.between(1, 100),
      picture_path: test_png_image_path
    }
  }

  before do
    create(:user_group, group: group, user: user, accepted_member: true)
    login_as(user, scope: :user, run_callbacks: false)
  end

  context 'without budget' do
    before { visit new_group_initiative_path(group) }

    scenario 'creating initiative without budget' do
      fill_form(initiative_params)

      submit_form

      # Expect new Initiative to be created
      expect(page).to have_current_path group_initiatives_path(group)

      expect(page).to have_content initiative_params[:name]

      check_initiative(initiative_params)
    end
  end

  context 'with budget item' do
    let!(:budget) { create :approved_budget, group: group, annual_budget: create(:annual_budget, group_id: group.id) }
    let!(:budget_item) { budget.budget_items.first }


    scenario 'creating initiative with budget' do
      visit new_group_initiative_path(group)
      
      allow_any_instance_of(Initiative).to receive(:estimated_funding).and_return(10000)

      fill_form(initiative_params)
      select(budget_item.title_with_amount, from: 'initiative_budget_item_id')

      submit_form

      # Expect new Initiative to be created
      expect(page).to have_current_path group_initiatives_path(group)

      expect(page).to have_content initiative_params[:name]

      check_initiative(initiative_params)

      # check that budget is allocated
      budget_item.reload
      expect(budget_item.is_done).to eq true
      expect(budget_item.available_amount).to eq 0
    end

    scenario 'updating initiative with budget' do
      initiative = create(:initiative, owner_group: group)
      budget = create(:approved_budget, group: group, annual_budget: create(:annual_budget, group_id: group.id))
      budget_item1 = budget.budget_items.first
      budget_item1.update(estimated_amount: 15000, available_amount: 15000)

      visit edit_group_initiative_path(group, initiative)

      select(budget_item1.title_with_amount, from: 'initiative_budget_item_id')

      click_on 'Submit'

      expect(page).to have_content "$#{initiative.estimated_funding.to_f}"
    end
  end

  context 'display closed status' do
    let!(:annual_budget) { create(:annual_budget, group: group, amount: group.annual_budget) }
    let!(:initiative1) { create(:initiative, owner_group: group, annual_budget_id: annual_budget.id,
                                             start: DateTime.now << 2, end: DateTime.now << 1)
    }
    let!(:budget1) { create(:approved_budget, group: group, annual_budget_id: annual_budget.id) }

    before do
      budget_item1 = budget1.budget_items.first
      initiative1.update(budget_item_id: budget_item1.id)
      create(:initiative_expense, description: 'new expense', amount: 10, initiative_id: initiative1.id, annual_budget_id: annual_budget.id)
    end

    scenario 'on group initiatives index page', js: true do
      visit group_initiative_expenses_path(group, initiative1)

      click_on 'Finish Expenses'

      expect(page).to have_content '(closed)'
    end
  end

  context 'without budget item' do
    context 'creating initiative without any approved budget items' do
      before { visit new_group_initiative_path(group) }

      scenario "hide 'Specify amount to deduct from budget' field" do
        expect(page).not_to have_field 'Specify amount to deduct from budget'
      end

      scenario 'disable budget item field' do
        expect(page).to have_field 'Attach a budget to the event.', disabled: true
      end
    end

    context 'updating initiative without any approved budget items' do
      before do
        initiative = create(:initiative, owner_group: group)
        visit edit_group_initiative_path(group, initiative)
      end

      scenario "hide 'Specify amount to deduct from budget' field" do
        expect(page).not_to have_field 'Specify amount to deduct from budget'
      end

      scenario 'disable budget item field' do
        expect(page).to have_field 'Attach a budget to the event.', disabled: true
      end
    end
  end

  context 'with leftover money' do
    let!(:budget) { create :approved_budget, group: group }
    let!(:budget_item) { budget.budget_items.first }
    let(:leftover) { rand(100..1000) }

    before do
      group.update(leftover_money: leftover)
      visit new_group_initiative_path(group)
    end

    scenario 'creating initiative with leftover money' do
      allow_any_instance_of(Initiative).to receive(:estimated_funding).and_return(leftover)

      fill_form(initiative_params)

      select(group.title_with_leftover_amount, from: 'initiative_budget_item_id')

      submit_form

      # Expect new Initiative to be created
      expect(page).to have_current_path group_initiatives_path(group)

      expect(page).to have_content initiative_params[:name]

      check_initiative(initiative_params)

      # Check that group leftover was decreased
      group.reload
      # expect(group.leftover_money).to eq 0

      expect(Initiative.last.estimated_funding).to eq leftover
    end
  end


  def fill_form(initiative_params)
    fill_in 'initiative_name', with: initiative_params[:name]
    fill_in 'initiative_description', with: initiative_params[:description]
    fill_in 'initiative_location', with: initiative_params[:location]
    fill_in 'initiative_start', with: format_date_time(initiative_params[:start])
    fill_in 'initiative_end', with: format_date_time(initiative_params[:end])
    fill_in 'initiative_max_attendees', with: initiative_params[:max_attendees]
    attach_file 'initiative_picture', initiative_params[:picture_path]
  end

  def check_initiative(initiative_params)
    # Check all the fields of newly created initiative
    visit edit_group_initiative_path(group, Initiative.last)

    expect(page).to have_field('initiative_name', with: initiative_params[:name])
    expect(page).to have_field('initiative_description', with: initiative_params[:description])
    expect(page).to have_field('initiative_location', with: initiative_params[:location])
    expect(format_date_time(DateTime.parse(find_field('initiative_start').value)))
      .to eq format_date_time(initiative_params[:start])
    expect(format_date_time(DateTime.parse(find_field('initiative_end').value)))
      .to eq format_date_time(initiative_params[:end])

    expect(page).to have_field('initiative_max_attendees', with: initiative_params[:max_attendees])

    # bTODO how to check that we have image?
    # expect(page).to have_field('initiative_picture', with: initiative_params[:picture_path])

    # Check initiative on employees dashboard
    visit group_events_path(group)
    expect(page).to have_content initiative_params[:name]
  end

  def format_date_time(date_time)
    date_time.strftime('%Y-%m-%d %H:%m')
  end
end

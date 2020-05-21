require 'rails_helper'

RSpec.feature 'Financial Management' do
  let!(:enterprise) { create(:enterprise) }
  let!(:admin_user) { create(:user, enterprise: enterprise) }
  let!(:icon) { File.new('spec/fixtures/files/trophy_image.jpg') }
  let!(:competition_category) { create(:expense_category, enterprise_id: enterprise.id, name: 'hackathon', icon: icon) }

  before do
    admin_user.policy_group.manage_all = true
    admin_user.policy_group.save!
    login_as(admin_user, scope: :user)
  end

  context 'create' do
    before do
      visit expenses_path

      click_on 'New Item'

      fill_in 'expense[name]', with: 'In-house hackathon'
      fill_in 'expense[price]', with: 20000
      select competition_category.name, from: 'expense[category_id]'
    end

    scenario 'an expense', js: true do
      page.find('.segmented-control__item', text: 'Expense').click

      click_on 'Create Expense'

      expect(page).to have_flash_message 'Your expense was created'
      expect(page).to have_content 'In-house hackathon'
      expect(page).to have_content '$20,000'
      expect(page).to have_icon_image 'trophy_image'
    end

    scenario 'an income', js: true do
      page.find('.segmented-control__item', text: 'Income').click

      click_on 'Create Expense'

      expect(page).to have_flash_message 'Your expense was created'
      expect(page).to have_content 'In-house hackathon'
      expect(page).to have_content '$20,000'
      expect(page).to have_icon_image 'trophy_image'
    end
  end

  context 'edit and delete' do
    let!(:expense) { create(:expense, enterprise_id: enterprise.id, name: 'Trip to HQ', price: 20000,
                                      income: false, category: create(:expense_category, enterprise_id: enterprise.id, name: 'trip', icon: icon))
    }
    let!(:income) { create(:expense, enterprise_id: enterprise.id, name: 'Sales Festival', price: 45000,
                                     income: true, category: create(:expense_category, enterprise_id: enterprise.id,
                                                                                       name: 'Sales and Marketing', icon: icon))
    }

    before do
      visit expenses_path
    end

    context 'edit' do
      scenario 'an expense', js: true do
        expect(page).to have_content 'Trip to HQ'

        click_link 'Edit', href: edit_expense_path(expense)

        expect(page).to have_field('expense[name]', with: 'Trip to HQ')

        fill_in 'expense[name]', with: 'Product Launch'

        click_on 'Update Expense'

        expect(page).to have_content 'Product Launch'
        expect(page).to have_no_content 'Trip to HQ'
      end

      scenario 'an income', js: true do
        expect(page).to have_content 'Sales Festival'

        click_link 'Edit', href: edit_expense_path(income)

        expect(page).to have_field('expense[name]', with: 'Sales Festival')

        fill_in 'expense[name]', with: 'Customer Outreach'

        click_on 'Update Expense'

        expect(page).to have_content 'Customer Outreach'
        expect(page).to have_no_content 'Sales Festival'
      end
    end

    context 'delete' do
      scenario 'an expense', js: true do
        expect(page).to have_content 'Trip to HQ'

        page.accept_confirm(with: 'Are you sure?') do
          click_link 'Delete', href: expense_path(expense)
        end

        expect(page).to have_no_content 'Trip to HQ'
      end

      scenario 'an income', js: true do
        expect(page).to have_content 'Sales Festival'

        page.accept_confirm(with: 'Are you sure?') do
          click_link 'Delete', href: expense_path(income)
        end

        expect(page).to have_no_content 'Sales Festival'
      end
    end

    context 'reset', skip: 'temporarily' do
      let!(:group) { create(:group, enterprise: enterprise) }
      before { visit close_budgets_groups_path }

      scenario 'annual budget', js: true do
        page.accept_confirm(with: "Before you reset this annual budget please make sure you
					have exported budget info for #{group.name}. Once you reset, all budget-related info will be permanently deleted") do
          click_link 'Reset Budget', href: reset_annual_budget_group_budgets_path(group)
        end
      end
    end
  end
end

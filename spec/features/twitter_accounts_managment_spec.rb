require 'rails_helper'
RSpec.feature 'Twitter Account Management' do
  let!(:user) { create(:user) }
  let!(:group) { create(:group, name: 'Group ONE', enterprise: user.enterprise) }

  before { login_as(user, scope: :user) }

  # visit group_twitter_accounts_path(group)

  def create_custom_accounts
    create(:twitter_account, name: 'Alex Oxorn', account: 'ADiverst', group_id: group.id)
    create(:twitter_account, name: 'Jack Douglas', account: 'jacksfilms', group_id: group.id)
    create(:twitter_account, name: 'Sonic', account: 'sonic_hedgehog', group_id: group.id)
    create(:twitter_account, name: 'Alex Oxorn2', account: 'AOxorn', group_id: group.id)
  end

  def create_single_csutom_account
    create(:twitter_account, name: 'Alex Oxorn', account: 'ADiverst', group_id: group.id)
  end

  it 'shows the twitter manager button with proper link' do
    visit group_posts_path(group)
    expect(page).to have_content('Manage Twitter Feed')
    click_link('Manage Twitter Feed')
    expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")
  end

  context 'No Accounts' do
    before do
      visit(group_twitter_accounts_path(group))
    end

    it 'should show correct header' do
      expect(page).to have_content('Twitter Accounts Following')
    end

    describe 'Adding Accounts' do

      scenario 'Add New Account' do

        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'Alex Oxorn'
        fill_in '* Account', with: '@ADIVERST'

        click_button('Follow User')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to have_content('Alex Oxorn')
        expect(page).to have_content('@ADIVERST')
      end

      scenario 'Adding Account, then canceling before submitting' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'Alex Oxorn'
        fill_in '* Account', with: 'ADIVERST'

        click_link('Cancel')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to_not have_content('Alex Oxorn')
        expect(page).to_not have_content('@ADIVERST')
      end

      scenario 'Add New Account (Invalid account name)' do
        click_link('+ Add Account')

        fill_in '* Name', with: 'Alex Oxorn'
        fill_in '* Account', with: 'uewbfvajksdbvlhksadbjcvhabdsfjkvnkjdasfvn'

        click_button('Follow User')

        expect(page).to have_content('User doesn\'t exist')
      end

      scenario 'Add New Account Empty Fields' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        click_button('Follow User')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to have_content('Name can\'t be blank')
        expect(page).to have_content('Account can\'t be blank')
      end

    end
  end

  context 'Accounts Exist' do
    before do
      create_custom_accounts
      visit(group_twitter_accounts_path(group))
    end

    it 'should show correct header' do
      expect(page).to have_content('Twitter Accounts Following')
    end

    it 'should show the accounts which are being followed' do
      expect(page).to have_content('Alex Oxorn')
      expect(page).to have_content('@ADiverst')
      expect(page).to have_content('Jack Douglas')
      expect(page).to have_content('@jacksfilms')
      expect(page).to have_content('Sonic')
      expect(page).to have_content('@sonic_hedgehog')
      expect(page).to have_content('Alex Oxorn2')
      expect(page).to have_content('@AOxorn')
    end

    describe 'Adding Accounts' do

      scenario 'Add New Account' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'ESPN'
        fill_in '* Account', with: 'espn'

        click_button('Follow User')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to have_content('ESPN')
        expect(page).to have_content('@espn')
      end

      scenario 'Adding Account, then canceling before submitting' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'ESPN'
        fill_in '* Account', with: 'espn'

        click_link('Cancel')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to_not have_content('ESPN')
        expect(page).to_not have_content('@espn')
      end

      scenario 'Add New Account (Invalid account name)' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'ESPN'
        fill_in '* Account', with: 'uewbfvajksdbvlhksadbjcvhabdsfjkvnkjdasfvn'

        click_button('Follow User')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to have_content('User doesn\'t exist')
      end

      scenario 'Add New Account with existing name' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'aLEX oXORN'
        fill_in '* Account', with: 'espn'

        click_button('Follow User')

        expect(page).to have_content('Name has already been taken')
      end

      scenario 'Add New Account with existing account' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'ESPN'
        fill_in '* Account', with: '@adIVERST'

        click_button('Follow User')

        expect(page).to have_content('Account has already been taken')
      end

      scenario 'Add New Account (Empty Fields)' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        click_button('Follow User')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to have_content('Name can\'t be blank')
        expect(page).to have_content('Account can\'t be blank')
      end

    end

    describe 'Deleting Accounts' do

      scenario 'Delete a particular account' do
        first(:link, 'Un-follow Account').click

        expect(page).to have_content('Alex Oxorn')
        expect(page).to have_content('@ADiverst')
        expect(page).to have_content('Jack Douglas')
        expect(page).to have_content('@jacksfilms')
        expect(page).to have_content('Sonic')
        expect(page).to have_content('@sonic_hedgehog')
        expect(page).to_not have_content('Alex Oxorn2')
        expect(page).to_not have_content('@AOxorn')
      end

      scenario 'Dekete All Accounts' do
        click_link('Un-follow All')

        expect(page).to_not have_content('Alex Oxorn')
        expect(page).to_not have_content('@ADiverst')
        expect(page).to_not have_content('Jack Douglas')
        expect(page).to_not have_content('@jacksfilms')
        expect(page).to_not have_content('Sonic')
        expect(page).to_not have_content('@sonic_hedgehog')
        expect(page).to_not have_content('Alex Oxorn2')
        expect(page).to_not have_content('@AOxorn')
      end

    end

    describe 'Editing Account' do

    end

  end

end
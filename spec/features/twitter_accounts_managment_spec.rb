require 'rails_helper'
RSpec.feature 'Twitter Account Management' do
  let!(:user) { create(:user) }
  let!(:group) { create(:group, name: 'Group ONE', enterprise: user.enterprise) }

  before do
    skip('Looking into Twitter Errors')
    login_as(user, scope: :user)
  end

  # visit group_twitter_accounts_path(group)

  def create_custom_accounts
    create(:twitter_account, name: 'Jack Douglas', account: 'jacksfilms', group_id: group.id)
    create(:twitter_account, name: 'Sonic', account: 'sonic_hedgehog', group_id: group.id)
    create(:twitter_account, name: 'Alex Oxorn2', account: 'AOxorn', group_id: group.id)
  end

  def create_single_custom_account
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

        fill_in '* Name', with: 'Jack Douglas'
        fill_in '* Account', with: '@jacksfilms'

        click_button('Follow User')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to have_content('Jack Douglas')
        expect(page).to have_content('@jacksfilms')
        expect(page).to_not have_content('@@jacksfilms')
      end

      scenario 'Adding Account, then canceling before submitting' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'Jack Douglas'
        fill_in '* Account', with: 'jacksfilms'

        click_link('Cancel')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to_not have_content('Jack Douglas')
        expect(page).to_not have_content('@jacksfilms')
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
    before(:each) do
      create_custom_accounts
      visit(group_twitter_accounts_path(group))
    end

    it 'should show correct header' do
      expect(page).to have_content('Twitter Accounts Following')
    end

    it 'should show the accounts which are being followed' do
      expect(page).to have_content('Jack Douglas')
      expect(page).to have_content('@jacksfilms')
      expect(page).to_not have_content('@@jacksfilms')
      expect(page).to have_content('Sonic')
      expect(page).to have_content('@sonic_hedgehog')
      expect(page).to_not have_content('@@sonic_hedgehog')
      expect(page).to have_content('Alex Oxorn2')
      expect(page).to have_content('@AOxorn')
      expect(page).to_not have_content('@@AOxorn')
    end

    describe 'Adding Accounts' do
      scenario 'Add New Account' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'ESPN'
        fill_in '* Account', with: '@@@espn'

        click_button('Follow User')

        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

        expect(page).to have_content('ESPN')
        expect(page).to have_content('@espn')
        expect(page).to_not have_content('@@espn')
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

        fill_in '* Name', with: 'aLEX oXORN2'
        fill_in '* Account', with: 'espn'

        click_button('Follow User')

        expect(page).to have_content('Name has already been taken')
      end

      scenario 'Add New Account with existing account' do
        click_link('+ Add Account')
        expect(current_path).to eql("/groups/#{group.id}/twitter_accounts/new")

        fill_in '* Name', with: 'ESPN'
        fill_in '* Account', with: '@JaCkSfIlMs'

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
      scenario 'Delete a particular account from Index' do
        first(:link, 'Un-follow Alex Oxorn2').click

        expect(page).to have_content('Jack Douglas')
        expect(page).to have_content('@jacksfilms')
        expect(page).to_not have_content('@@jacksfilms')
        expect(page).to have_content('Sonic')
        expect(page).to have_content('@sonic_hedgehog')
        expect(page).to_not have_content('@@sonic_hedgehog')
        expect(page).to_not have_content('Alex Oxorn2')
        expect(page).to_not have_content('@AOxorn')
      end

      scenario 'Delete All Accounts' do
        click_link('Un-follow All')

        expect(page).to_not have_content('Jack Douglas')
        expect(page).to_not have_content('@jacksfilms')
        expect(page).to_not have_content('Sonic')
        expect(page).to_not have_content('@sonic_hedgehog')
        expect(page).to_not have_content('Alex Oxorn2')
        expect(page).to_not have_content('@AOxorn')
      end

      scenario 'Delete a particular account from show' do
        first(:link, 'See More Tweets From Alex Oxorn2').click
        first(:link, 'Un-follow Alex Oxorn2').click

        expect(page).to have_content('Jack Douglas')
        expect(page).to have_content('@jacksfilms')
        expect(page).to_not have_content('@@jacksfilms')
        expect(page).to have_content('Sonic')
        expect(page).to have_content('@sonic_hedgehog')
        expect(page).to_not have_content('@@sonic_hedgehog')
        expect(page).to_not have_content('Alex Oxorn2')
        expect(page).to_not have_content('@AOxorn')
      end
    end

    describe 'Editing Account' do
      context 'From Index' do
        before do
          first(:link, 'Edit Alex Oxorn2\'s Information').click
          @to_edit_account = find_field('* Account').value
          @to_edit_name = find_field('* Name').value
        end

        scenario 'Edit Account with existing account' do
          fill_in '* Account', with: '@jacksfilms'

          click_button('Follow User')

          expect(page).to have_content('Account has already been taken')
        end

        scenario 'Edit Account with existing name' do
          fill_in '* Name', with: 'jACK dOUGLAS'

          click_button('Follow User')

          expect(page).to have_content('Name has already been taken')
        end

        scenario 'Edit Account adding extra @s' do
          fill_in '* Account', with: "@@@@@@#{@to_edit_account}"

          click_button('Follow User')
          expect(page).to have_content("#{@to_edit_name}")
          expect(page).to have_content("@#{@to_edit_account}")
          expect(page).to_not have_content("@@#{@to_edit_account}")
        end

        scenario 'Edit Account' do
          fill_in '* Name', with: 'ESPN'
          fill_in '* Account', with: '@@@espn'

          click_button('Follow User')

          expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

          expect(page).to have_content('ESPN')
          expect(page).to have_content('@espn')
          expect(page).to_not have_content('@@espn')
        end

        scenario 'Edit Account, then canceling before submitting' do
          fill_in '* Name', with: 'ESPN'
          fill_in '* Account', with: '@@espn'

          click_link('Cancel')

          expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

          expect(page).to_not have_content('ESPN')
          expect(page).to_not have_content('@espn')
        end

        scenario 'Edit Account (Invalid account name)' do
          fill_in '* Account', with: 'uewbfvajksdbvlhksadbjcvhabdsfjkvnkjdasfvn'

          click_button('Follow User')

          expect(page).to have_content('User doesn\'t exist')
        end

        scenario 'Edit Account (Empty Fields)' do
          fill_in '* Account', with: ''
          fill_in '* Name', with: ''

          click_button('Follow User')

          expect(page).to have_content('Name can\'t be blank')
          expect(page).to have_content('Account can\'t be blank')
        end

        scenario 'Edit Account (Changing Cases)' do
          fill_in '* Name', with: "#{@to_edit_name.upcase}"
          fill_in '* Account', with: "@#{@to_edit_account.upcase}"

          click_button('Follow User')

          expect(page).to have_content("#{@to_edit_name.upcase}")
          expect(page).to have_content("@#{@to_edit_account.upcase}")
          expect(page).to_not have_content("@@#{@to_edit_account.upcase}")
        end
      end

      context 'From Show' do
        before do
          first(:link, 'See More Tweets From Alex Oxorn2').click
          first(:link, 'Edit Alex Oxorn2\'s Information').click
          @to_edit_account = find_field('* Account').value
          @to_edit_name = find_field('* Name').value
        end

        scenario 'Edit Account with existing account' do
          fill_in '* Account', with: '@jacksfilms'

          click_button('Follow User')

          expect(page).to have_content('Account has already been taken')
        end

        scenario 'Edit Account with existing name' do
          fill_in '* Name', with: 'jACK dOUGLAS'

          click_button('Follow User')

          expect(page).to have_content('Name has already been taken')
        end

        scenario 'Edit Account adding extra @s' do
          fill_in '* Account', with: "@@@@@@#{@to_edit_account}"

          click_button('Follow User')
          expect(page).to have_content("#{@to_edit_name}")
          expect(page).to have_content("@#{@to_edit_account}")
          expect(page).to_not have_content("@@#{@to_edit_account}")
        end

        scenario 'Edit Account' do
          fill_in '* Name', with: 'ESPN'
          fill_in '* Account', with: '@@@espn'

          click_button('Follow User')

          expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

          expect(page).to have_content('ESPN')
          expect(page).to have_content('@espn')
          expect(page).to_not have_content('@@espn')
        end

        scenario 'Edit Account, then canceling before submitting' do
          fill_in '* Name', with: 'ESPN'
          fill_in '* Account', with: '@@espn'

          click_link('Cancel')

          expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")

          expect(page).to_not have_content('ESPN')
          expect(page).to_not have_content('@espn')
        end

        scenario 'Edit Account (Invalid account name)' do
          fill_in '* Account', with: 'uewbfvajksdbvlhksadbjcvhabdsfjkvnkjdasfvn'

          click_button('Follow User')

          expect(page).to have_content('User doesn\'t exist')
        end

        scenario 'Edit Account (Empty Fields)' do
          fill_in '* Account', with: ''
          fill_in '* Name', with: ''

          click_button('Follow User')

          expect(page).to have_content('Name can\'t be blank')
          expect(page).to have_content('Account can\'t be blank')
        end

        scenario 'Edit Account (Changing Cases)' do
          fill_in '* Name', with: "#{@to_edit_name.upcase}"
          fill_in '* Account', with: "@#{@to_edit_account.upcase}"

          click_button('Follow User')

          expect(page).to have_content("#{@to_edit_name.upcase}")
          expect(page).to have_content("@#{@to_edit_account.upcase}")
          expect(page).to_not have_content("@@#{@to_edit_account.upcase}")
        end
      end
    end

    describe 'Viewing Account' do
      describe 'Seeing Full Timeline' do
        it 'Should have the correct titles' do
          first(:link, 'See More Tweets From Alex Oxorn2').click
          expect(page).to have_content('Alex Oxorn2\'s Tweets')
          expect(page).to have_content('@AOxorn')
          expect(page).to_not have_content('@@AOxorn')
        end

        it 'Should have a button that returns to index' do
          first(:link, 'See More Tweets From Alex Oxorn2').click
          click_link('Back To Account List')
          expect(current_path).to eql("/groups/#{group.id}/twitter_accounts")
        end
      end
    end
  end
end

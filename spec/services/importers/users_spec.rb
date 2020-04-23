require 'rails_helper'

RSpec.describe Importers::Users do
  let!(:enterprise) { create(:enterprise) }
  let!(:manager) { create(:user, enterprise: enterprise, user_role_id: enterprise.default_user_role) }
  let(:importer) { Importers::Users.new(file, manager) }
  let(:admin_role) { enterprise.user_roles.where(role_type: 'admin').first }

  context 'when spreadsheet does not have mandatory fields filled' do
    let(:file) do
      head = ['', '', '']
      rows = [['', '', '']]
      create_import_spreadsheet(head, rows)
    end

    it 'does not save invalid users' do
      expect { importer.import }.to_not change(User, :count)
    end

    it 'assign invalid users to @failed_rows with their errors' do
      importer.import
      expect(importer.failed_rows.first[:error].empty?)
        .to eq false
    end

    it '@successful_rows should be empty' do
      importer.import
      expect(importer.successful_rows).to eq []
    end
  end

  context 'when spreadsheet have email that does not exists in database' do
    let(:is_active_value) { [1, '1', true, 'true', 'TRUE', 'yes', 'YES', '', nil].sample }
    let(:user) { build(:user, :with_notifications_email) }
    let(:file) do
      head = [
        'First name',
        'Last name',
        'Email',
        'Notifications Email',
        'Active',
      ]
      rows = [
        [
          user.first_name,
          user.last_name,
          user.email,
          user.notifications_email,
          is_active_value,
          'Developer',
          'Male',
          '1992-01-25',
          'English',
          '20'
        ]
      ]
      create_import_spreadsheet(head, rows)
    end

    it 'creates a new user' do
      expect { importer.import }.to change(User, :count).by(1)
    end

    it 'saves all infos in the new user' do
      importer.import
      saved_user = User.last
      infos = saved_user.info

      expect(saved_user.first_name).to eq user.first_name
      expect(saved_user.last_name).to eq user.last_name
      expect(saved_user.email).to eq user.email
      expect(saved_user.notifications_email).to eq user.notifications_email
      expect(saved_user.active?).to eq true
    end

    it 'send an invite to created user' do
      expect_any_instance_of(User).to receive('invite!').with(manager, skip: false)
      importer.import
    end

    it 'assign created user to @successful_rows' do
      importer.import
      expect(importer.successful_rows).to_not be_empty
    end

    it '@failed_rows should be empty' do
      importer.import
      expect(importer.failed_rows).to eq []
    end
  end

  context 'when spreadsheet have email that already exists in database' do
    let(:is_active_false) { [false, 'false', 'FALSE', 'no', 'NO'].sample }
    let!(:user) do
      user = build(:user, :with_notifications_email, enterprise: enterprise, user_role_id: admin_role.id)
      user.active = true
      user.save!
      user
    end

    let(:file) do
      head = [
        'First name',
        'Last name',
        'Email',
        'Notifications email',
        'Active',
      ]
      rows = [
        [
          user.first_name,
          user.last_name,
          user.email,
          user.notifications_email,
          is_active_false,
          'Designer',
          'Female',
          'Spanish',
          ''
        ]
      ]
      create_import_spreadsheet(head, rows)
    end

    it 'does not create a new user' do
      expect { importer.import }.to_not change(User, :count)
    end

    it 'updates the user' do
      importer.import
      updated_user = User.last
      infos = updated_user.info

      expect(updated_user.first_name).to eq user.first_name
      expect(updated_user.last_name).to eq user.last_name
      expect(updated_user.email).to eq user.email
      expect(updated_user.notifications_email).to eq user.notifications_email
      expect(updated_user.active).to eq false
      expect(updated_user.user_role.role_type).to eq(admin_role.role_type)
    end

    it 'does not send an invite to created user' do
      expect_any_instance_of(User).to_not receive('invite!')
      importer.import
    end

    it 'assign created user to @successful_rows' do
      importer.import
      expect(importer.successful_rows).to_not be_empty
    end

    it '@failed_rows should be empty' do
      importer.import
      expect(importer.failed_rows).to eq []
    end
  end

  context 'when spreadsheet have email that already exists in database' do
    let(:is_active_false) { [false, 'false', 'FALSE', 'no', 'NO'].sample }
    let!(:user) do
      user = build(:user, :with_notifications_email, enterprise: enterprise, user_role_id: admin_role.id)
      user.active = true
      user.save!
      user
    end

    let(:file) do
      head = [
        'First name',
        'Last name',
        'Email',
        'Notifications email',
        'Active',
      ]
      rows = [
        [
          user.first_name,
          user.last_name,
          user.email,
          user.notifications_email,
          is_active_false,
          'Designer',
          'Female',
          'Spanish',
          ''
        ]
      ]
      create_import_spreadsheet(head, rows)
    end

    it 'does not create a new user' do
      expect { importer.import }.to_not change(User, :count)
    end

    it 'updates the user' do
      importer.import
      updated_user = User.last
      infos = updated_user.info

      expect(updated_user.first_name).to eq user.first_name
      expect(updated_user.last_name).to eq user.last_name
      expect(updated_user.email).to eq user.email
      expect(updated_user.notifications_email).to eq user.notifications_email
      expect(updated_user.active).to eq false
      expect(updated_user.user_role.role_type).to eq(admin_role.role_type)
    end

    it 'does not send an invite to created user' do
      expect_any_instance_of(User).to_not receive('invite!')
      importer.import
    end

    it 'assign created user to @successful_rows' do
      importer.import
      expect(importer.successful_rows).to_not be_empty
    end

    it '@failed_rows should be empty' do
      importer.import
      expect(importer.failed_rows).to eq []
    end
  end

  context 'when user has notification email already but notifications email column is empty' do
    let(:is_active_false) { [false, 'false', 'FALSE', 'no', 'NO'].sample }
    let!(:user) do
      user = build(:user, :with_notifications_email, enterprise: enterprise, user_role_id: admin_role.id)
      user.active = true
      user.save!
      user
    end

    let(:file) do
      head = [
        'First name',
        'Last name',
        'Email',
        'Notifications email',
        'Active',
      ]
      rows = [
        [
          user.first_name,
          user.last_name,
          user.email,
          '',
          is_active_false,
          'Designer',
          'Female',
          'Spanish',
          ''
        ]
      ]
      create_import_spreadsheet(head, rows)
    end

    it 'does not create a new user' do
      expect { importer.import }.to_not change(User, :count)
    end

    it 'updates the user' do
      importer.import
      updated_user = User.last
      infos = updated_user.info

      expect(updated_user.first_name).to eq user.first_name
      expect(updated_user.last_name).to eq user.last_name
      expect(updated_user.email).to eq user.email
      expect(updated_user.active).to eq false
      expect(updated_user.user_role.role_type).to eq(admin_role.role_type)
    end

    it 'does not remove existing notifications email' do
      importer.import
      updated_user = User.last
      infos = updated_user.info

      expect(updated_user.notifications_email).to eq user.notifications_email
      expect(updated_user.notifications_email).to_not be_empty
    end

    it 'does not send an invite to created user' do
      expect_any_instance_of(User).to_not receive('invite!')
      importer.import
    end

    it 'assign created user to @successful_rows' do
      importer.import
      expect(importer.successful_rows).to_not be_empty
    end

    it '@failed_rows should be empty' do
      importer.import
      expect(importer.failed_rows).to eq []
    end
  end
end

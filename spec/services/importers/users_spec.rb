require 'rails_helper'

RSpec.describe Importers::Users do
  let(:job_field) { TextField.new(title: 'Job title') }
  let(:gender_field) { SelectField.new(title: 'Gender') }
  let(:date_field) { DateField.new(title: 'Date of birth') }
  let(:languages_field) { CheckboxField.new(title: 'Spoken languages') }
  let(:years_field) { NumericField.new(title: 'Experience in your field (in years)') }
  let!(:enterprise) { create(:enterprise, fields: [job_field, gender_field, date_field, languages_field, years_field]) }
  let!(:manager) { create(:user, enterprise: enterprise, user_role_id: enterprise.default_user_role) }
  let(:importer) { Importers::Users.new(file, manager) }
  let(:admin_role) { enterprise.user_roles.where(role_type: 'admin').first }

  context 'when spreadsheet does not have mandaroty fields filled' do
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
      expect(importer.failed_rows.first[:error])
        .to eq "Email can't be blank, First name can't be blank, Last name can't be blank"
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
        job_field.title,
        gender_field.title,
        date_field.title,
        languages_field.title,
        years_field.title
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
      expect(infos.fetch(job_field.id)).to eq 'Developer'
      expect(infos.fetch(gender_field.id)).to eq ['Male']
      expect(infos.fetch(date_field.id)).to eq Time.strptime('1992-01-25', '%F').to_i
      expect(infos.fetch(languages_field.id)).to eq ['English']
      expect(infos.fetch(years_field.id)).to eq 20
    end

    it 'send an invite to created user' do
      expect_any_instance_of(User).to receive('invite!').with(manager)
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
      user.info[job_field] = 'Developer'
      user.info[gender_field] = 'Male'
      user.info[languages_field] = 'English'
      user.info[date_field] = date_field.process_field_value '1992-01-25'
      user.info[years_field] = 20
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
        job_field.title,
        gender_field.title,
        languages_field.title,
        years_field.title
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
      expect(infos.fetch(job_field.id)).to eq 'Designer'
      expect(infos.fetch(gender_field.id)).to eq ['Female']
      expect(infos.fetch(date_field.id)).to eq Time.strptime('1992-01-25', '%F').to_i
      expect(infos.fetch(languages_field.id)).to eq ['Spanish']
      expect(infos.fetch(years_field.id)).to eq 20
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
      user.info[job_field] = 'Developer'
      user.info[gender_field] = 'Male'
      user.info[languages_field] = 'English'
      user.info[date_field] = date_field.process_field_value '1992-01-25'
      user.info[years_field] = 20
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
        job_field.title,
        gender_field.title,
        languages_field.title,
        years_field.title
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
      expect(infos.fetch(job_field.id)).to eq 'Designer'
      expect(infos.fetch(gender_field.id)).to eq ['Female']
      expect(infos.fetch(date_field.id)).to eq Time.strptime('1992-01-25', '%F').to_i
      expect(infos.fetch(languages_field.id)).to eq ['Spanish']
      expect(infos.fetch(years_field.id)).to eq 20
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
      user.info[job_field] = 'Developer'
      user.info[gender_field] = 'Male'
      user.info[languages_field] = 'English'
      user.info[date_field] = date_field.process_field_value '1992-01-25'
      user.info[years_field] = 20
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
        job_field.title,
        gender_field.title,
        languages_field.title,
        years_field.title
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
      expect(infos.fetch(job_field.id)).to eq 'Designer'
      expect(infos.fetch(gender_field.id)).to eq ['Female']
      expect(infos.fetch(date_field.id)).to eq Time.strptime('1992-01-25', '%F').to_i
      expect(infos.fetch(languages_field.id)).to eq ['Spanish']
      expect(infos.fetch(years_field.id)).to eq 20
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

require 'rails_helper'

RSpec.describe User::Actions, type: :model do
  describe 'csv_attributes' do
    let(:csv_attributes) {
      [
          'First name',
          'Last name',
          'Email',
          'Biography',
          'Active',
          'Group Membership'
      ]
    }
    it { expect(User.csv_attributes.dig(:titles)).to eq csv_attributes }
  end

  let(:user_role) { create(:user_role, role_name: 'test role') }
  let(:group) { create(:group, name: 'test group') }

  describe 'parameter_name' do
    it 'raises an exception if scope is missing' do
      expect { User.parameter_name({}) }.to raise_error(ArgumentError)
    end
    it { expect(User.parameter_name(['of_role', [user_role.id]])).to eq user_role.role_name }
    it { expect(User.parameter_name('all')).to eq 'all' }
    it { expect(User.parameter_name('active')).to eq 'active' }
    it { expect(User.parameter_name('inactive')).to eq 'inactive' }
    it { expect(User.parameter_name('saml')).to eq 'sso authorized' }
    it { expect(User.parameter_name('invitation_sent')).to eq 'pending' }
  end

  describe 'base_query' do
    it { expect(User.base_query).to eq 'users.id LIKE :search OR LOWER(users.first_name) LIKE :search OR LOWER(users.last_name) LIKE :search OR LOWER(users.email) LIKE :search' }
  end

  describe 'valid_scopes' do
    let(:valid_scopes) {
      %w(
          enterprise_mentors
          mentors
          mentees
          accepting_mentee_requests
          accepting_mentor_requests
          all
          active
          inactive
          saml
          invitation_sent
          of_role
          not_member_of_group
      )
    }

    it { expect(User.valid_scopes).to eq valid_scopes }
  end

  describe 'preload_attachments' do
    let(:preload_attachments) { [:avatar] }

    it { expect(User.preload_attachments).to eq preload_attachments }
  end

  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :field_data,
          :avatar_attachment,
          :avatar_blob,
          :user_role,
          field_data: [
              :field,
              field: Field.base_preloads(Request.create_request(nil))
          ],
      ]
    }

    it { expect(User.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end

  describe 'base_attribute_preloads' do
    let(:base_attribute_preloads) {
      [
          :user_role,
          :avatar_attachment,
      ]
    }

    it { expect(User.base_attribute_preloads).to eq base_attribute_preloads }
  end

  describe 'mentor_lite_includes' do
    let(:mentor_lite_includes) {
      [
          :mentoring_interests,
          :mentoring_types,
          :availabilities
      ]
    }

    it { expect(User.mentor_lite_includes).to eq mentor_lite_includes }
  end

  describe 'mentor_includes' do
    let(:mentor_includes) {
      [
          :mentoring_interests,
          :mentoring_types,
          :mentors,
          :mentees,
          :mentorship_ratings,
          :availabilities,
          mentors: [
              :mentoring_interests,
              :mentoring_types,
              :availabilities
          ],
          mentees: [
              :mentoring_interests,
              :mentoring_types,
              :availabilities
          ]
      ]
    }

    it { expect(User.mentor_includes).to eq mentor_includes }
  end

  describe 'signin' do
    it 'raises an exception if email or password is missing' do
      expect { User.signin(nil, nil) }.to raise_error(BadRequestException, 'Email and password required')
    end

    it 'raises an exception if user does not exist' do
      expect { User.signin('test@gmail.com', 'testPassword') }.to raise_error(BadRequestException, 'User does not exist')
    end

    it 'raises an exception if password is incorrect' do
      create(:user, email: 'test@gmail.com')
      expect { User.signin('test@gmail.com', 'testPassword') }.to raise_error(BadRequestException, 'Incorrect password')
    end

    it 'signs in successfully' do
      create(:user, email: 'test@gmail.com', password: 'testPassword')
      expect(User.signin('test@gmail.com', 'testPassword').sign_in_count).to eq 1
    end
  end

  describe 'find_user_by_email' do
    let!(:user) { create(:user, email: 'test@gmail.com') }

    it 'raises an exception if user does not exist' do
      expect { User.find_user_by_email(Request.create_request(user), { email: 'wrong@gmail.com' }) }.to raise_error(BadRequestException, 'User does not exist')
    end

    it 'finds the user' do
      expect(User.find_user_by_email(Request.create_request(user), { email: user.email })).to eq user
    end
  end

  describe 'send_reset_password_instructions', skip: 'Deprecated' do
    let!(:user) { create(:user) }

    it 'raises an exception' do
      user.update(reset_password_token: 'test')
      expect { user.send_reset_password_instructions }.to raise_error(BadRequestException)
    end

    it 'resets password' do
      user.send_reset_password_instructions
      expect(user.reset_password_sent_at).to_not be nil
      expect(user.reset_password_token).to_not be nil
    end
  end

  describe 'valid_reset_password_token?', skip: 'Deprecated' do
    let!(:user) { create(:user) }

    it 'returns false if token is blank' do
      expect(user.valid_reset_password_token?('')).to be false
    end

    it 'returns false if reset_password_sent_at is blank' do
      expect(user.valid_reset_password_token?('test')).to be false
    end

    it 'returns false if token is expired' do
      valid_time = Time.now - Rails.configuration.password_reset_time_frame.hours
      user.update(reset_password_sent_at: valid_time - 1.hour)
      expect(user.valid_reset_password_token?('test')).to be false
    end

    it 'returns true' do
      token = user.send_reset_password_instructions
      expect(user.valid_reset_password_token?(token)).to be true
    end
  end

  describe 'reset_password_by_token', skip: 'Deprecated' do
    let!(:user) { create(:user) }
    it 'resets password' do
      params = {
          password: 'testPassword',
          password_confirmation: 'testPassword',
      }
      user.send_reset_password_instructions
      reset_user = user.reset_password_by_token(params)
      expect(reset_user.reset_password_token).to be nil
      expect(reset_user.reset_password_sent_at).to be nil
      expect(reset_user.password).to eq 'testPassword'
    end
  end

  describe 'request_password_reset!' do
    let!(:user) { create(:user) }
    it 'creates resets password request' do
      mailer = double('mailer')
      expect(ResetPasswordMailer).to receive(:reset_password_instructions) { mailer }
      expect(mailer).to receive(:deliver_later)

      user.request_password_reset!
      expect(user.reset_password_sent_at).to_not be nil
      expect(user.reset_password_token).to_not be nil
    end
  end

  describe 'invite!' do
    let!(:user) { create(:user) }
    it 'invites the user' do
      mailer = double('mailer')
      expect(DiverstMailer).to receive(:invitation_instructions) { mailer }
      expect(mailer).to receive(:deliver_later)

      user.invite!
      expect(user.invitation_sent_at).to_not be nil
      expect(user.invitation_created_at).to_not be nil
      expect(user.invitation_token).to_not be nil
    end
  end

  describe 'sign_up' do
    let!(:enterprise) { create(:enterprise) }
    let!(:user_exist) { create(:user, email: 'test@gmail.com') }
    let!(:user) { create(:user, invitation_accepted_at: nil) }

    it 'raises an exception' do
      expect { user.sign_up({ email: 'test@gmail.com' }) }.to raise_error(InvalidInputException)
    end
    it 'signs up successfully' do
      params = {
          first_name: 'first',
          last_name: 'last',
          password: 'testPassword',
          password_confirmation: 'testPassword',
          biography: 'test',
          time_zone: ActiveSupport::TimeZone.find_tzinfo('UTC').name,
      }
      signed_up_user = user.sign_up(params)
      expect(signed_up_user.invitation_accepted_at).to_not be nil
      expect(signed_up_user.first_name).to eq 'first'
      expect(signed_up_user.last_name).to eq 'last'
      expect(signed_up_user.biography).to eq 'test'
      expect(signed_up_user.time_zone).to eq 'Etc/UTC'
    end
  end

  describe 'reset_password' do
    let!(:enterprise) { create(:enterprise) }
    let!(:user_exist) { create(:user, email: 'test@gmail.com') }
    let!(:user) { create(:user, invitation_accepted_at: nil) }

    it 'raises an exception' do
      expect { user.sign_up({
                                password: 'testPassword',
                                password_confirmation: 'testPassword2'
                            })
      }.to raise_error(InvalidInputException)
    end
    it 'signs up successfully' do
      params = {
          password: 'testPassword',
          password_confirmation: 'testPassword',
      }
      password_reset_user = user.reset_password(params)
      expect(password_reset_user.valid_password?('testPassword')).to be true
    end
  end

  describe 'post' do
    let!(:user) { create(:user) }
    let!(:group) { create(:group, latest_news_visibility: 'group') }
    let!(:public_group) { create(:group, latest_news_visibility: 'public') }
    let!(:group_leader_only) { create(:group) }

    before {
      create(:user_group, user: user, group: group)
      create(:user_group, user: user, group: public_group)
      create(:user_group, user: user, group: group_leader_only)
      create_list(:group_message, 3, group_id: group.id)
      create_list(:news_link, 3, group_id: public_group.id)
      create_list(:social_link, 3, group_id: group_leader_only.id)
      GroupMessage.first.news_feed_link.update(archived_at: Date.today)
      NewsLink.first.news_feed_link.update(approved: false)
    }

    it { expect(user.posts(Request.create_request(user), {}).total).to eq 4 }
  end

  describe 'downloads' do
    it 'gets download files' do
      user = create(:user)
      csv_files = create_list(:csv_file_download, 3, user: user)
      downloads = user.downloads(Request.create_request(user), {})
      expect(downloads.total).to eq csv_files.count
    end
  end

  describe 'index_except_self' do
    it 'gets users except itself' do
      users = create_list(:user, 10)
      index_except_self = User.first.index_except_self({ order_by: 'id', order: 'asc' })
      expect(index_except_self.total).to eq users.count - 1
      expect(index_except_self.attributes[:items].first).to_not eq User.first
    end
  end
end

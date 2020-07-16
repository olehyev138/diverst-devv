require 'rails_helper'

RSpec.describe User::Actions, type: :model do
  describe 'csv_attributes' do
    it { expect(User.csv_attributes.dig(:titles)).to eq ['First name', 'Last name', 'Email', 'Biography', 'Active', 'Group Membership'] }
  end

  let(:user_role) { create(:user_role, role_name: 'test role') }
  let(:group) { create(:group, name: 'test group') }
  describe 'parameter_name' do
    it 'scope error' do
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
    it { expect(User.valid_scopes.include?('enterprise_mentors')).to eq true }
    it { expect(User.valid_scopes.include?('mentors')).to eq true }
    it { expect(User.valid_scopes.include?('mentees')).to eq true }
    it { expect(User.valid_scopes.include?('accepting_mentee_requests')).to eq true }
    it { expect(User.valid_scopes.include?('accepting_mentor_requests')).to eq true }
    it { expect(User.valid_scopes.include?('all')).to eq true }
    it { expect(User.valid_scopes.include?('active')).to eq true }
    it { expect(User.valid_scopes.include?('inactive')).to eq true }
    it { expect(User.valid_scopes.include?('saml')).to eq true }
    it { expect(User.valid_scopes.include?('invitation_sent')).to eq true }
    it { expect(User.valid_scopes.include?('of_role')).to eq true }
  end

  describe 'preload_attachments' do
    it { expect(User.preload_attachments.include?(:avatar)).to eq true }
  end

  describe 'base_preloads' do
    it { expect(User.base_preloads.include?(:field_data)).to eq true }
    it { expect(User.base_preloads.include?(:enterprise)).to eq true }
    it { expect(User.base_preloads.include?(:user_groups)).to eq true }
    it { expect(User.base_preloads.include?(:user_role)).to eq true }
    it { expect(User.base_preloads.include?(:news_links)).to eq true }
    it { expect(User.base_preloads.include?(:avatar_attachment)).to eq true }
    it { expect(User.base_preloads.include?(:avatar_blob)).to eq true }
    it { expect(User.base_preloads.include?({ field_data: [:field, { field: [:field_definer] }],
                                              enterprise: [:theme, :mobile_fields] })).to eq true
    }
  end

  describe 'base_attribute_preloads' do
    it { expect(User.base_attribute_preloads.include?(:enterprise)).to eq true }
    it { expect(User.base_attribute_preloads.include?(:user_role)).to eq true }
    it { expect(User.base_attribute_preloads.include?(:news_links)).to eq true }
    it { expect(User.base_attribute_preloads.include?(:avatar_attachment)).to eq true }
    it { expect(User.base_attribute_preloads.include?({ enterprise: [:theme, :mobile_fields] })).to eq true }
  end

  describe 'mentor_lite_includes' do
    it { expect(User.mentor_lite_includes.include?(:mentoring_interests)).to eq true }
    it { expect(User.mentor_lite_includes.include?(:mentoring_types)).to eq true }
    it { expect(User.mentor_lite_includes.include?(:availabilities)).to eq true }
  end

  describe 'mentor_includes' do
    it { expect(User.mentor_includes.include?(:mentoring_interests)).to eq true }
    it { expect(User.mentor_includes.include?(:mentoring_types)).to eq true }
    it { expect(User.mentor_includes.include?(:availabilities)).to eq true }
    it { expect(User.mentor_includes.include?(:mentors)).to eq true }
    it { expect(User.mentor_includes.include?(:mentees)).to eq true }
    it { expect(User.mentor_includes.include?(:mentorship_ratings)).to eq true }
    it { expect(User.mentor_includes.include?({ mentees: [:mentoring_interests, :mentoring_types, :availabilities],
                                                mentors: [:mentoring_interests, :mentoring_types, :availabilities] })).to eq true
    }
  end

  describe 'signin' do
    it 'missing email or password' do
      expect { User.signin(nil, nil) }.to raise_error(BadRequestException, 'Email and password required')
    end

    it 'user does not exist' do
      expect { User.signin('test@gmail.com', 'testPassword') }.to raise_error(BadRequestException, 'User does not exist')
    end

    it 'Incorrect password' do
      create(:user, email: 'test@gmail.com')
      expect { User.signin('test@gmail.com', 'testPassword') }.to raise_error(BadRequestException, 'Incorrect password')
    end

    it 'signin success' do
      create(:user, email: 'test@gmail.com', password: 'testPassword')
      expect(User.signin('test@gmail.com', 'testPassword').sign_in_count).to eq 1
    end
  end

  describe 'find_user_by_email' do
    let!(:user) { create(:user, email: 'test@gmail.com') }

    it 'user does not exist' do
      expect { User.find_user_by_email(Request.create_request(user), { email: 'wrong@gmail.com' }) }.to raise_error(BadRequestException, 'User does not exist')
    end

    it 'user is found' do
      expect(User.find_user_by_email(Request.create_request(user), { email: user.email })).to eq user
    end
  end

  describe 'send_reset_password_instructions' do

  end

  describe 'valid_reset_password_token?' do

  end

  describe 'reset_password_by_token' do

  end

  describe 'sign_up' do

  end

  describe 'post' do
    let!(:user) { create(:user) }
    let!(:group) { create(:group, latest_news_visibility: 'public') }
    let!(:group_leader_only) { create(:group, latest_news_visibility: 'public') }

    before {
      create(:user_group, user: user, group: group)
      create_list(:group_message, 3, group_id: group.id)
      create_list(:group_message, 3, group_id: group_leader_only.id)
    }

    it do
      expect(user.posts({}).total).to eq 3
    end
  end

  describe 'downloads' do
    it do
      user = create(:user)
      csvFiles = create_list(:csv_file_download, 3, user: user)
      downloads = Request.create_request(user).user.downloads({})
      expect(downloads.total).to eq csvFiles.count
    end
  end

  describe 'index_except_self' do
    it do
      users = create_list(:user, 10)
      index_except_self = User.first.index_except_self({ order_by: 'id', order: 'asc' })
      expect(index_except_self.total).to eq users.count - 1
      expect(index_except_self.attributes[:items].first).to_not eq User.first
    end
  end
end

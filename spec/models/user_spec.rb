require 'rails_helper'

RSpec.describe User do
  include ActiveJob::TestHelper
  it_behaves_like 'it Contains Field Data'

  describe 'when validating' do
    let(:user) { build(:user) }

    it { expect(user).to define_enum_for(:groups_notifications_frequency).with_values([:hourly, :daily, :weekly, :disabled]) }
    it { expect(user).to define_enum_for(:groups_notifications_date).with_values([:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]) }

    it 'validates password presence' do
      pending 'Need to find alternate solution for validating users'
      user = build(:user, password: nil)
      expect(user.valid?).to be(false)
      expect(user.errors.full_messages.first).to eq("Password can't be blank")
    end

    it 'validates password length' do
      user = build(:user, password: 'imshort')
      expect(user.valid?).to be(false)
      expect(user.errors.full_messages.first).to eq('Password is too short (minimum is 8 characters)')
    end

    it 'validates email presence' do
      user = build(:user, email: nil)
      expect(user.valid?).to be(false)
      expect(user.errors.full_messages.first).to eq("Email can't be blank")
    end

    it 'validates email format' do
      user = build(:user, email: 'test')

      expect(user.valid?).to be(false)
      expect(user.errors.full_messages.first).to eq('Email is invalid')
    end

    describe '#notifications_date' do
      it 'returns sunday' do
        user = create(:user, groups_notifications_date: 0)
        expect(user.groups_notifications_date).to eq('sunday')
      end
      it 'returns default monday' do
        user = create(:user, groups_notifications_date: 1)
        expect(user.groups_notifications_date).to eq('monday')
      end
      it 'returns tuesday' do
        user = create(:user, groups_notifications_date: 2)
        expect(user.groups_notifications_date).to eq('tuesday')
      end
      it 'returns wednesday' do
        user = create(:user, groups_notifications_date: 3)
        expect(user.groups_notifications_date).to eq('wednesday')
      end
      it 'returns thursday' do
        user = create(:user, groups_notifications_date: 4)
        expect(user.groups_notifications_date).to eq('thursday')
      end
      it 'returns default friday' do
        user = create(:user)
        expect(user.groups_notifications_date).to eq('friday')
      end
      it 'returns saturday' do
        user = create(:user, groups_notifications_date: 6)
        expect(user.groups_notifications_date).to eq('saturday')
      end
    end

    context 'test validations' do
      it { expect(user).to validate_presence_of(:first_name) }
      it { expect(user).to validate_presence_of(:last_name) }
      it { expect(user).to validate_presence_of(:points) }
      it { expect(user).to validate_numericality_of(:points).only_integer }
      it { expect(user).to validate_presence_of(:credits) }
      it { expect(user).to validate_numericality_of(:credits).only_integer }
      # it { expect(user).to validate_presence_of(:time_zone) } # test fails because of set default time_zone
      it { expect(user).to validate_length_of(:mentorship_description).is_at_most(65535) }
      it { expect(user).to validate_length_of(:unlock_token).is_at_most(191) }
      it { expect(user).to validate_length_of(:time_zone).is_at_most(191) }
      it { expect(user).to validate_length_of(:biography).is_at_most(65535) }
      it { expect(user).to validate_length_of(:yammer_token).is_at_most(191) }
      it { expect(user).to validate_length_of(:firebase_token).is_at_most(191) }
      it { expect(user).to validate_length_of(:tokens).is_at_most(65535) }
      it { expect(user).to validate_length_of(:uid).is_at_most(191) }
      it { expect(user).to validate_length_of(:invited_by_type).is_at_most(191) }
      it { expect(user).to validate_length_of(:invitation_token).is_at_most(191) }
      it { expect(user).to validate_length_of(:last_sign_in_ip).is_at_most(191) }
      it { expect(user).to validate_length_of(:current_sign_in_ip).is_at_most(191) }
      it { expect(user).to validate_length_of(:reset_password_token).is_at_most(191) }
      it { expect(user).to validate_length_of(:email).is_at_most(191) }
      it { expect(user).to validate_length_of(:encrypted_password).is_at_most(191) }
      it { expect(user).to validate_length_of(:notifications_email).is_at_most(191) }
      it { expect(user).to validate_length_of(:auth_source).is_at_most(191) }
      it { expect(user).to validate_length_of(:data).is_at_most(65535) }
      it { expect(user).to validate_length_of(:last_name).is_at_most(191) }
      it { expect(user).to validate_length_of(:first_name).is_at_most(191) }
      it { expect(user).to validate_length_of(:password).is_at_least(8).is_at_most(128), allow_value('', nil) }

      it { expect(user).to validate_presence_of(:email) }
      it { expect(user).to validate_presence_of(:first_name) }
      it { expect(user).to validate_presence_of(:last_name) }

      it { expect(user).to validate_confirmation_of(:password) }
      it { expect(user).to validate_uniqueness_of(:email) }
      it { expect(user).to allow_value('email@addresse.foo').for(:email) }
      it { expect(user).to_not allow_value('foo').for(:email) }
      it 'provider length validation' do
        user.uid = 'test'
        expect(user).to validate_length_of(:provider).is_at_most(191)
      end
    end

    context 'test associations' do
      context 'belongs_to associations' do
        # we dont validate presence of enterprise on user - TODO
        it { expect(user).to belong_to(:enterprise).without_validating_presence.counter_cache(true) }
        it { expect(user).to belong_to(:user_role) }
      end

      context 'has_one associations' do
        it { expect(user).to have_one(:policy_group).dependent(:destroy).inverse_of(:user) }
        it { expect(user).to have_one(:device).dependent(:destroy).inverse_of(:user) }
      end

      context 'has_many associations' do
        it { expect(user).to have_many(:activities) }
        it { expect(user).to have_many(:sessions).dependent(:destroy) }
        it { expect(user).to have_many(:users_segments).dependent(:destroy) }
        it { expect(user).to have_many(:segments).through(:users_segments) }
        it { expect(user).to have_many(:groups).through(:user_groups) }
        it { expect(user).to have_many(:managed_groups).with_foreign_key(:manager_id).class_name('Group') }
        it { expect(user).to have_many(:user_groups).dependent(:destroy) }
        it { expect(user).to have_many(:topic_feedbacks).dependent(:destroy) }
        it { expect(user).to have_many(:poll_responses) }
        it { expect(user).to have_many(:answers).inverse_of(:author).with_foreign_key(:author_id).dependent(:destroy) }
        it { expect(user).to have_many(:answer_upvotes).with_foreign_key(:author_id).dependent(:destroy) }
        it { expect(user).to have_many(:answer_comments).with_foreign_key(:author_id).dependent(:destroy) }
        it { expect(user).to have_many(:invitations).class_name('CampaignInvitation').dependent(:destroy) }
        it { expect(user).to have_many(:campaigns).through(:invitations) }
        it { expect(user).to have_many(:news_links).through(:groups) }
        it { expect(user).to have_many(:own_news_links).class_name('NewsLink').with_foreign_key(:author_id).dependent(:destroy) }
        it { expect(user).to have_many(:messages).through(:groups) }
        it { expect(user).to have_many(:message_comments).class_name('GroupMessageComment').with_foreign_key(:author_id) }
        it { expect(user).to have_many(:social_links).with_foreign_key(:author_id).dependent(:destroy) }
        it { expect(user).to have_many(:initiative_users).dependent(:destroy) }
        it { expect(user).to have_many(:initiatives).through(:initiative_users).source(:initiative) }
        it { expect(user).to have_many(:initiative_invitees).dependent(:destroy) }
        it { expect(user).to have_many(:invited_initiatives).through(:initiative_invitees).source(:initiative) }
        it { expect(user).to have_many(:managed_groups).with_foreign_key(:manager_id).class_name('Group') }
        it { expect(user).to have_many(:group_leaders).dependent(:destroy) }
        it { expect(user).to have_many(:leading_groups).through(:group_leaders).source(:group) }
        it { expect(user).to have_many(:user_reward_actions).dependent(:destroy) }
        it { expect(user).to have_many(:reward_actions).through(:user_reward_actions) }
        it { expect(user).to have_many(:user_rewards) }
        it { expect(user).to have_many(:rewards).with_foreign_key(:responsible_id).dependent(:destroy) }
        it { expect(user).to have_many(:metrics_dashboards).with_foreign_key(:owner_id) }
        it { expect(user).to have_many(:shared_metrics_dashboards) }
        it { expect(user).to have_many(:mentorships).class_name('Mentoring').with_foreign_key('mentor_id') }
        it { expect(user).to have_many(:mentees).through('mentorships').class_name('User').source(:mentee) }
        it { expect(user).to have_many(:menteeships).class_name('Mentoring').with_foreign_key('mentee_id') }
        it { expect(user).to have_many(:mentors).through(:menteeships).class_name('User').source(:mentor) }
        it { expect(user).to have_many(:availabilities).class_name('MentorshipAvailability') }
        it { expect(user).to have_many(:mentorship_ratings) }
        it { expect(user).to have_many(:mentorship_interests) }
        it { expect(user).to have_many(:mentoring_interests).through('mentorship_interests') }
        it { expect(user).to have_many(:mentorship_sessions) }
        it { expect(user).to have_many(:mentoring_sessions).through('mentorship_sessions') }
        it { expect(user).to have_many(:mentorship_types) }
        it { expect(user).to have_many(:mentoring_types).through('mentorship_types') }
        it { expect(user).to have_many(:mentorship_proposals).with_foreign_key('sender_id').class_name('MentoringRequest') }
        it { expect(user).to have_many(:mentorship_requests).with_foreign_key('receiver_id').class_name('MentoringRequest') }
        it { expect(user).to have_many(:own_messages).with_foreign_key(:owner_id).class_name('GroupMessage') }
        it { expect(user).to have_many(:likes).dependent(:destroy) }
        it { expect(user).to have_many(:csv_files) }
        it { expect(user).to have_many(:urls_visited).dependent(:destroy).class_name('PageVisitationData') }
        it { expect(user).to have_many(:pages_visited).dependent(:destroy).class_name('PageVisitation') }
        it { expect(user).to have_many(:page_names_visited).dependent(:destroy).class_name('PageVisitationByName') }
        it { expect(user).to have_many(:answer_comments).with_foreign_key(:author_id).dependent(:destroy) }
        it { expect(user).to have_many(:news_link_comments).with_foreign_key(:author_id).dependent(:destroy) }
      end

      # ActiveStorage
      it { expect(user).to have_attached_file(:avatar) }
      it { expect(user).to validate_attachment_content_type(:avatar, AttachmentHelper.common_image_types) }

      it { expect(user).to accept_nested_attributes_for(:policy_group) }
      it { expect(user).to accept_nested_attributes_for(:availabilities).allow_destroy(true) }
    end

    describe 'test callbacks' do
      let!(:new_enterprise) { create(:enterprise) }
      let!(:new_user) { build(:user, enterprise: new_enterprise) }
      let!(:created_user) { create(:user) }
      let!(:user_with_linkedin) { build(:user, enterprise: new_enterprise, linkedin_profile_url: 'linkedin.com/public/in/linusupson?trk=org-k&challengeId=AQHOBon8J8')
      }

      describe 'before_validation callbacks' do
        context '#generate_password_if_saml' do
          it 'should be called before validation is triggered' do
            expect(new_user).to receive(:generate_password_if_saml)
            new_user.valid?
          end

          it 'set valid password on before_validation callback for a new user object' do
            expect(new_user.valid_password?(new_user.password)).to eq true
            new_user.valid?
          end
        end

        context '#set_provider' do
          it 'should be called before validation is triggered' do
            expect(new_user).to receive(:set_provider)
            new_user.valid?
          end

          it 'sets provider on before_validation callback for a new user object' do
            expect(new_user.provider.present?).to be true
          end
        end

        context '#set_uid' do
          it 'should be called before validation is triggered' do
            expect(new_user).to receive(:set_uid)
            new_user.valid?
          end

          it 'sets uid on before_validation callback for a new user object' do
            new_user.send(:set_uid)
            expect(new_user.present?).to eq true
          end
        end

        context '#set_timezone' do
          it 'should be called before validation is triggered' do
            expect(new_user).to receive(:set_timezone)
            new_user.valid?
          end

          it 'sets timezone on before_validation callback for a new user object' do
            new_user.send(:set_timezone)
            expect(new_user.present?).to eq true
          end
        end

        context '#add_linked_in_http' do
          it 'should not be called before validation is triggered when linkedin is null' do
            expect(new_user).to_not receive(:add_linkedin_http)
            new_user.valid?
          end

          it 'sets linkedin on before_validation callback for a new user object' do
            user_with_linkedin.send(:add_linkedin_http)
            expect(user_with_linkedin.present?).to eq true
          end
        end
      end

      describe 'before_destroy callbacks' do
        context '#check_lifespan_of_user' do
          let!(:user1) { create :user }
          let!(:user2) { create :user, created_at: 20.days.ago, updated_at: 20.days.ago }

          it 'deletes user younger than 14 days' do
            expect { user1.destroy }.to change(User.all, :count).by(-1)
          end

          it 'does not delete user older than 14 days' do
            expect { user2.destroy }.to change(User.all, :count).by(0)
          end
        end
      end

      describe 'after_save callbacks' do
        context 'set_default_policy_group' do
          it 'create policy_group when policy_group is not set' do
            new_user.save
            expect(new_user.policy_group.present?).to eq true
          end
        end
      end

      describe 'after_create callbacks' do
        context 'set_default_policy_group' do
          it 'create policy_group' do
            expect(created_user.policy_group.present?).to eq true
          end
        end
      end

      describe 'after_update callbacks' do
        context 'add_to_default_mentor_group' do
          it 'when saved_change_to_mentor? and saved_change_to_mentee? are false' do
            expect { created_user.update(first_name: 'abc') }.to_not have_enqueued_job(DefaultMentorGroupMemberUpdateJob)
          end

          it 'when saved_change_to_mentor or mentee is true' do
            expect { created_user.update(mentor: true) }.to have_enqueued_job(DefaultMentorGroupMemberUpdateJob)
          end
        end
      end
    end

    context 'presence of fields' do
      let!(:mandatory_field) { build(:field, title: 'Test', required: true) }
      let!(:enterprise) { create(:enterprise, fields: [mandatory_field]) }
      let(:user) { create(:user, enterprise: enterprise) }

      context 'with mandatory fields not filled' do
        it 'should have an error on user' do
          user[mandatory_field] = ''
          user.valid?

          expect(user.errors.messages).to match(hash_including({ test: ["can't be blank"] }))
        end
      end

      context 'with mandatory fields filled' do
        it 'should be valid' do
          user[mandatory_field] = Faker::Lorem.paragraph(2)

          expect(user).to be_valid
        end
      end
    end
  end

  describe 'when describing callbacks' do
    let!(:user) { create(:user) }

    it 'should index user on elasticsearch after create', skip: true do
      user = build(:user)
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'index',
          index: User.es_index_name(enterprise: user.enterprise),
          record_id: User.last.id + 1
        )
        user.save
      end
    end

    it 'should reindex user on elasticsearch after update', skip: true do
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'update',
          index: User.es_index_name(enterprise: user.enterprise),
          record_id: user.id
        )
        user.update(first_name: 'test')
      end
    end

    it 'should remove user from elasticsearch after destroy', skip: true do
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'delete',
          index: User.es_index_name(enterprise: user.enterprise),
          record_id: user.id
        )
        user.destroy
      end
    end
  end

  describe 'scopes' do
    let(:enterprise) { create :enterprise }
    let!(:active_user) { create :user, enterprise: enterprise }
    let!(:inactive_user) { create :user, enterprise: enterprise, active: false }

    describe '#active' do
      it 'only returns active users' do
        active_users = enterprise.users.active

        expect(active_users).to include active_user
        expect(active_users).to_not include inactive_user
      end
    end

    describe '#inactive' do
      it 'only returns inactive user' do
        inactive_users = enterprise.users.inactive

        expect(inactive_users).to include inactive_user
        expect(inactive_users).to_not include active_user
      end
    end

    describe '#for_segments' do
      let!(:segment) { create(:segment, enterprise_id: enterprise.id) }
      let!(:user_segment) { create(:users_segment, user_id: active_user.id, segment_id: segment.id) }

      it 'returns users with segments' do
        segments = active_user.segments
        expect(enterprise.users.for_segments(segments)).to eq [active_user]
      end
    end

    describe '#for_groups' do
      let!(:group) { create(:group, enterprise_id: enterprise.id) }
      let!(:user_group) { create(:user_group, user_id: active_user.id, group_id: group.id) }

      it 'returns users with groups' do
        groups = active_user.groups
        expect(enterprise.users.for_groups(groups)).to eq [active_user]
      end
    end

    describe '#answered_poll' do
      let!(:poll) { create(:poll, enterprise_id: enterprise.id) }
      let!(:response) { create(:poll_response, user_id: active_user.id, poll_id: poll.id) }

      it 'returns users with answered polls' do
        expect(enterprise.users.answered_poll(poll)).to eq [active_user]
      end
    end

    describe '#invitation_sent' do
      it 'returns invitation_sent' do
        expect(User.active.invitation_sent).to eq [active_user]
      end
    end

    describe '#top_participants' do
      let!(:user1) { create(:user, total_weekly_points: 1) }
      let!(:user2) { create(:user, total_weekly_points: 2) }
      let!(:user3) { create(:user, total_weekly_points: 3) }
      let!(:user4) { create(:user, total_weekly_points: 4) }
      it 'returns top_participants' do
        expect(User.top_participants(2)[0]).to eq(user4)
        expect(User.top_participants(2)[1]).to eq(user3)
      end
    end

    describe '#of_role' do
      let!(:users) { create_list(:user, 3) }
      before do
        User.update_all(user_role_id: 1)
        users[0].update(user_role_id: 2)
      end

      it 'returns user of role' do
        expect(User.of_role(2).count).to eq 1
      end
    end

    describe '#es_index_for_enterprise' do
      let!(:enterprise1) { create :enterprise }
      let!(:users) { create_list(:user, 3, enterprise: enterprise1) }

      it 'returns es_index_for_enterprise' do
        expect(User.es_index_for_enterprise(enterprise1).count).to eq 3
      end
    end

    describe '#saml' do
      let!(:user_saml) { create(:user, auth_source: 'saml') }
      it 'returns es_index_for_enterprise' do
        expect(User.saml).to eq([user_saml])
      end
    end

    describe 'mentors' do
      let!(:mentors) { create_list(:user, 3, mentor: true) }

      it 'returns mentors' do
        expect(User.mentors.count).to eq 3
      end
    end

    describe 'not_member_of_group' do
      let!(:enterprise) { create(:enterprise) }
      let!(:group1) { create(:group, name: 'groupA', enterprise: enterprise) }
      let!(:group2) { create(:group, name: 'groupB', enterprise: enterprise) }

      let!(:user1) { create(:user, groups: [], enterprise: enterprise) }
      let!(:user2) { create(:user, group_ids: [group1.id], enterprise: enterprise) }
      let!(:user3) { create(:user, group_ids: [group2.id], enterprise: enterprise) }
      let!(:user4) { create(:user, group_ids: [group1.id, group2.id], enterprise: enterprise) }

      let(:not_A_users) do
        User.not_member_of_group(group1.id).pluck(:first_name)
      end

      it 'does not include members of a group' do
        expect(not_A_users).not_to include(user2.first_name)
        expect(not_A_users).not_to include(user4.first_name)
      end

      it 'returns all users who are not a member of a group' do
        expect(not_A_users).to include(user1.first_name)
        expect(not_A_users).to include(user3.first_name)
      end
    end

    describe 'mentees' do
      let!(:mentees) { create_list(:user, 3, mentee: true) }

      it 'returns mentees' do
        expect(User.mentees.count).to eq 3
      end
    end

    describe 'accepting_mentor_requests' do
      let!(:accepting_mentor_requests) { create_list(:user, 3, accepting_mentor_requests: true) }

      it 'returns accepting_mentor_requests' do
        expect(User.accepting_mentor_requests.count).to eq 5
      end
    end

    describe 'accepting_mentee_requests' do
      let!(:accepting_mentee_requests) { create_list(:user, 3, accepting_mentee_requests: true) }

      it 'returns accepting_mentor_requests' do
        expect(User.accepting_mentee_requests.count).to eq 5
      end
    end

    describe 'mentors_and_mentees' do
      let!(:mentees) { create_list(:user, 2, mentee: true) }
      let!(:montors) { create_list(:user, 2, mentor: true) }
      let!(:montor_mentee) { create(:user, mentor: true, mentee: true) }
      it 'returns mentors_and_mentees' do
        expect(User.mentors_and_mentees.count).to eq 5
      end
    end

    describe 'enterprise_mentors' do
      before do
        create(:user, id: 1, mentor: true)
        create(:user, id: 2, mentor: true)
        create(:user, id: 3, mentor: true)
      end
      it 'returns enterprise_mentors' do
        expect(User.enterprise_mentors(user_ids = [1, 2]).count).to eq 1
      end
    end

    describe 'enterprise_mentees' do
      before do
        create(:user, id: 1, mentee: true)
        create(:user, id: 2, mentee: true)
        create(:user, id: 3, mentee: true)
      end
      it 'returns enterprise_mentees' do
        expect(User.enterprise_mentees(user_ids = [1]).count).to eq 2
      end
    end
  end

  describe '#build' do
    it 'sets the avatar when creating user' do
      user = create(:user)
      allow(URI).to receive(:parse).and_return(File.open('spec/fixtures/files/verizon_logo.png'))
      request = Request.create_request(user)

      avatar = fixture_file_upload('spec/fixtures/files/verizon_logo.png', 'image/png')

      payload = {
        user: {
          first_name: 'Save',
          last_name: 'My Avatar',
          enterprise_id: user.enterprise_id,
          email: 'avatar@gmail.com',
          user_role_id: user.user_role_id,
          password: SecureRandom.hex(8),
          avatar: avatar
        }
      }
      params = ActionController::Parameters.new(payload)
      created = User.build(request, params.permit!)

      expect(created.avatar.attached?).to be true
    end
  end

  describe '#avatar_location' do
    it 'returns the actual avatar location' do
      user = create(:user, avatar: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })

      expect(user.avatar_location).to_not be nil
    end
  end

  describe '#generate_authentication_token' do
    it 'generates a random token which doesnt already exist' do
      user = create(:user)
      expect(user.generate_authentication_token).to_not be nil
      expect(user.generate_authentication_token.length).to be 20
      expect(Session.find_by(token: user.generate_authentication_token)).to be nil
    end
  end

  describe '#generate_invitation_token' do
    it 'generates an invitation token' do
      user = create(:user)
      expect(user.generate_invitation_token).to_not be nil
      # TODO : check if the update has been completed
    end
  end

  describe '#invite' do
    # TODO : Fix
    xit 'expects mailing to have been enqueued' do
      user = create(:user)
      user.invite!
      expect(DiverstMailer).to have_been_enqueued
      # expect{user.invite!}.to have_enqueued_job(ActionMailer)
    end
  end

  describe '#valid_password?' do
    it 'when the password is valid' do
      user = create(:user)
      expect(user.valid_password?(user.password)).to eq true
    end

    it 'when the password is invalid ' do
      user = create(:user)
      expect(user.valid_password?('a')).to eq false
    end
  end

  describe '#policy_user_group' do
    it 'when there is no matching policy for the provided group' do
      user = create(:user)
      expect(user.policy_user_group(-1)).to eq nil
    end

    it 'when there is a matching policy for the provided group' do
      user = create(:user)
      group = create(:group)
      user_groups = create(:user_group, user: user, group: group)
      expect(user.policy_user_group(group.id)).to eq user_groups
    end
  end

  describe '#policy_group_leader' do
    it 'when there is no matching policy for the provided group' do
      user = create(:user)
      expect(user.policy_group_leader(-1)).to eq nil
    end

    it 'when there is a matching policy for the provided group' do
      user = create(:user)
      group = create(:group)
      group_leader = create(:group_leader, user: user, group: group)
      expect(user.policy_group_leader(group.id)).to eq group_leader
    end
  end

  describe '#policy_initiative_user' do
    it 'when there is no matching policy for the provided event' do
      user = create(:user)
      expect(user.policy_initiative_user(-1)).to eq nil
    end

    it 'when there is a matching policy for the provided event' do
      user = create(:user)
      initiative = create(:initiative)
      initiative_user = create(:initiative_user, user: user, initiative: initiative)
      expect(user.policy_initiative_user(initiative.id)).to eq initiative_user
    end
  end

  describe '#pending_rewards' do
    let!(:user) { create(:user) }
    let!(:reward) { create(:reward, enterprise: user.enterprise, points: 10) }
    let!(:pending_rewards) { create_list(:user_reward, 2, reward_id: reward.id, points: 10, user_id: user.id, status: 0) }
    let!(:redeemed_rewards) { create_list(:user_reward, 2, reward_id: reward.id, points: 10, user_id: user.id, status: 1) }

    it 'should return pending_rewards' do
      expect(user.pending_rewards).to eq(pending_rewards)
    end

    it 'should return redeemed rewards' do
      expect(user.redeemed_rewards).to eq(redeemed_rewards)
    end
  end

  describe '#email_for_notification' do
    let(:user) { create(:user, notifications_email: 'user@email.com') }

    context 'when email_for_notification is set' do
      it 'notifications_email attribute should not be nil or empty string' do
        expect(user.email_for_notification).not_to be_nil
        expect(user.email_for_notification).not_to be_empty
      end

      it 'returns selected email for notification' do
        expect(user.email_for_notification).to eq(user.notifications_email)
      end
    end

    context 'when email_for_notification is not set' do
      let(:user1) { create(:user) }

      it 'returns default email' do
        expect(user1.email_for_notification).to eq(user1.email)
      end
    end
  end

  describe '#last_notified_date' do
    it 'returns nil when last_group_notification_date is not set' do
      user = create(:user)
      expect(user.last_notified_date).to eq nil
    end

    it 'returns in date format last_group_notification_date when set' do
      user = create(:user)
      user.update(last_group_notification_date: Time.now)
      expect(user.last_notified_date).to eq user.last_group_notification_date&.to_date
    end
  end

  describe '#is_group_leader_of?' do
    it 'when user is not a leader of the provided group' do
      user = create(:user)
      group = create(:group)
      expect(user.is_group_leader_of?(group)).to eq false
    end

    it 'when user is a leader of the provided group' do
      user = create(:user)
      group = create(:group)
      group_leader = create(:group_leader, group: group, user: user)
      expect(user.is_group_leader_of?(group)).to eq true
    end
  end

  describe '#is_member_of?' do
    it 'when user is not a member of the provided group' do
      user = create(:user)
      group = create(:group)
      expect(user.is_member_of?(group)).to eq false
    end

    it 'when user is a member of the provided group' do
      user = create(:user)
      group = create(:group)
      user_groups = create(:user_group, group: group, user: user)
      expect(user.is_member_of?(group)).to eq true
    end
  end

  describe '#is_attending?' do
    it 'when user is not a member of the provided group' do
      user = create(:user)
      event = create(:initiative)
      expect(user.is_attending?(event)).to eq false
    end

    it 'when user is a member of the provided group' do
      user = create(:user)
      initiative = create(:initiative)
      initiative_users = create(:initiative_user, user: user, initiative: initiative)
      expect(user.is_attending?(initiative)).to eq true
    end
  end

  describe '#is_participating_in?' do
    it 'when user is not participating in the session' do
      user = create(:user)
      session = create(:session)
      expect(user.is_participating_in?(session)).to eq false
    end

    it 'when user is participating in the session' do
      user = create(:user)
      session = create(:session)
      mentorship_session = create(:mentorship_session)
      mentorship_session.update(user_id: user.id)
      expect(user.is_participating_in?(session)).to eq true
    end
  end

  describe '#is_not_member_of' do
    it 'when user is not a member of the provided group' do
      user = create(:user)
      group = create(:group)
      expect(user.is_not_member_of?(group)).to eq true
    end

    it 'when user is a member of the provided group' do
      user = create(:user)
      group = create(:group)
      user_groups = create(:user_group, group: group, user: user)
      expect(user.is_not_member_of?(group)).to eq false
    end
  end

  describe '#last_initial' do
    it 'returns the initial of the last_name capitalized followed by a dot' do
      user = create(:user, last_name: 'abc')
      expect(user.last_initial).to eq 'A.'
    end
  end

  describe '#default_time_zone' do
    context 'when timezone is not set' do
      it 'returns the timezone of the enterprise' do
        enterprise = create(:enterprise)
        user = build_stubbed(:user, time_zone: nil, enterprise: enterprise)
        expect(user.default_time_zone).to eq enterprise.time_zone
      end
    end

    context 'when timezone is set ' do
      it 'returns the value of timezone' do
        user = build_stubbed(:user, time_zone: 'America/New_York')
        expect(user.default_time_zone).to eq 'America/New_York'
      end
    end
  end

  describe '#match_score_with' do
    it 'when the user and other_user dont have any matches' do
      user = create(:user, last_name: 'abc')
      other_user = create(:user, last_name: 'abc')
      expect(user.match_score_with(other_user)).to eq 0
    end

    xit 'when both users have matches' do
      # TODO : Test involving matches needed
    end
  end

  describe '#matches' do
    # TODO : Testing to be done
  end

  describe '#active_matches' do
    # TODO : Testing to be done
  end

  describe '#top_matches' do
    # TODO : Testing to be done
  end

  describe 'is_part_of_segment?' do
    it 'when segment.general_rules_followed_by user is false' do
      user = create(:user)
      segment = create(:segment)
      expect(user.is_part_of_segment?(segment)).to eq true
    end

    context 'when segment.general_rules_followed_by user is true' do
      xit 'returns true when field_rules are followed by the user' do
        # TODO : Testing to be done
      end

      it 'returns false when field_rules are not follower by the user' do
        # TODO: Testing to be done
      end
    end
  end

  describe '#to_csv_with_fields' do
    let!(:users) { create_list(:user, 3) }
    let!(:fields) { create_list(:field, 3) }
    it 'returns csv' do
      headers = 'First name,Last name,Email,Biography,Active,Group Membership,' + fields[0].title + ',' + fields[1].title + ',' + fields[2].title
      enterprise = create(:enterprise)
      segment = create(:segment)
      members = enterprise.users.joins(:segments).where(segments: { id: segment.id }).distinct
      expect(User.to_csv_with_fields users: members, fields: fields).to include(headers)
    end
  end

  describe '#basic_info_to_csv' do
    let!(:users) { create_list(:user, 3) }
    let!(:fields) { create_list(:field, 3) }
    it 'returns csv' do
      enterprise = create(:enterprise)
      segment = create(:segment)
      members = enterprise.users.joins(:segments).where(segments: { id: segment.id }).distinct
      expect(User.basic_info_to_csv users: members).to include('First name,Last name,Email')
    end
  end

  describe '#aggregate_sign_ins' do
    # TODO : Testing to be done
  end

  describe '#group_member?' do
    it 'when user is member of the group' do
      enterprise = create(:enterprise)
      user = create(:user)
      group = create(:group, enterprise: enterprise)
      user_group = create(:user_group, user: user, group: group)
      expect(user.group_member?(group.id)).to eq true
    end

    it 'when user is not a member of the group' do
      enterprise = create(:enterprise)
      user = create(:user)
      group = create(:group, enterprise: enterprise)
      expect(user.group_member?(group.id)).to eq false
    end
  end

  describe '#pending_group_member?' do
    context 'when user is member of the group' do
      it 'when user is not a pending member' do
        enterprise = create(:enterprise)
        user = create(:user, enterprise: enterprise)
        group = create(:group, enterprise: enterprise)
        user_group = create(:user_group, user: user, group: group)
        expect(user.pending_group_member?(group.id)).to eq false
      end

      it 'when user is a pending member' do
        enterprise = create(:enterprise)
        user = create(:user, enterprise: enterprise)
        group = create(:group, enterprise: enterprise)
        user_group = create(:user_group, user: user, group: group)
        group.update(pending_users: true)
        user_group.update(accepted_member: false)
        expect(user.pending_group_member?(group.id)).to eq false
      end
    end

    it 'when user is not a member of the group' do
      user = create(:user)
      group = create(:group)
      expect(user.pending_group_member?(group.id)).to eq false
    end
  end

  describe '#active_group_member?' do
    context 'when user is member of the group' do
      it 'when user is an active member' do
        enterprise = create(:enterprise)
        user = create(:user, enterprise: enterprise)
        group = create(:group, enterprise: enterprise)
        user_group = create(:user_group, user: user, group: group)
        expect(user.active_group_member?(group.id)).to eq true
      end

      it 'when user is an active member' do
        enterprise = create(:enterprise)
        user = create(:user, enterprise: enterprise)
        group = create(:group, enterprise: enterprise)
        user_group = create(:user_group, user: user, group: group)
        group.update(pending_users: true)
        user_group.update(accepted_member: false)
        expect(user.active_group_member?(group.id)).to eq true
      end
    end

    it 'when user is not a member of the group' do
      user = create(:user)
      group = create(:group)
      expect(user.active_group_member?(group.id)).to eq false
    end
  end

  describe '#set_provider' do
    xit 'when uid is nil' do
      user = create(:user)
      user.update(uid: nil)
      expect(user.set_provider).to eq 'email'
    end
  end

  describe '#set_uid' do
    it 'when uid is blank' do
      user = create(:user)
      user.update(uid: '')
      expect(user.set_uid).to eq nil
    end
  end

  describe '#set_timezone' do
    it 'time_zone is already set' do
      user = create(:user)
      expect(user.set_timezone).to eq user.time_zone
    end
  end

  describe '#erg_leader?' do
    let!(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }

    subject { user.erg_leader? }

    context 'when user is a leader of an erg' do
      before do
        create(:user_group, user: user, group: group, accepted_member: true)
        group.group_leaders << GroupLeader.new(group: group, user: user, position_name: 'blah', user_role: user.enterprise.user_roles.where(role_name: 'group_leader').first)
      end

      it 'returns true' do
        expect(subject).to eq true
      end
    end

    context 'when user is not a leader of an erg' do
      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end

  describe '#badges' do
    before { pending }

    let(:user) { build_stubbed(:user, points: 100) }
    let(:badge_one) { create(:badge, points: 100) }
    let(:badge_two) { create(:badge, points: 101) }

    it 'returns the badges based on how much points a user has' do
      expect(user.badges).to eq [badge_one]
    end
  end

  describe '#active_group_member?' do
    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:group) { create(:group, enterprise: enterprise, pending_users: 'enabled') }

    subject { user.active_group_member?(group.id) }

    context 'when user is not group member' do
      it 'is false' do
        expect(subject).to eq false
      end
    end

    context 'when user is a group member' do
      before { user.groups << group }

      context 'when user is not accepted' do
        it 'is false' do
          expect(subject).to eq false
        end
      end

      context 'when user is accepted' do
        before do
          user_group = user.user_groups.where(group_id: group.id).first
          user_group.update(accepted_member: true)
        end

        it 'is true' do
          expect(subject).to eq true
        end
      end
    end
  end

  describe '#name' do
    let(:user) { build_stubbed(:user, first_name: 'John', last_name: 'Doe') }

    it 'return the full name of user' do
      expect(user.name).to eq 'John Doe'
    end
  end

  describe '#name_with_status' do
    context 'of an active user' do
      let(:user) { build_stubbed(:user, first_name: 'John', last_name: 'Doe', active: true) }

      it 'return the full name of user' do
        expect(user.name_with_status).to eq 'John Doe'
      end
    end

    context 'of an inactive user' do
      let(:user) { build_stubbed(:user, first_name: 'John', last_name: 'Doe', active: false) }

      it 'return the full name of user with status' do
        expect(user.name_with_status).to eq 'John Doe (inactive)'
      end
    end
  end

  describe 'group surveys' do
    let(:user) { create(:user) }
    let(:group) { create(:group, enterprise: user.enterprise) }
    let(:sample_data) { '{\"96\":\"save me 2\",\"98\":\"I am borisano and this is survey\",\"100\":[\"two\"],\"101\":[\"one\",\"two\"],\"102\":40,\"103\":null}' }
    let!(:user_group) { create :user_group, user: user, group: group, data: sample_data }

    describe '#has_answered_group_survey?' do
      subject { user.has_answered_group_survey? }

      context 'with group survey answered' do
        it 'return true' do
          expect(subject).to eq true
        end
      end

      context 'with group survey not answered' do
        let(:sample_data) { nil }

        it 'returns false' do
          expect(subject).to eq false
        end
      end
    end

    describe '#has_answered_group_survey?' do
      subject { user.has_answered_group_survey?(group: group) }

      context 'with group survey answered' do
        it 'return true' do
          expect(subject).to eq true
        end
      end

      context 'with group survey not answered' do
        let(:sample_data) { nil }

        it 'returns false' do
          expect(subject).to eq false
        end
      end
    end
  end

  describe 'elasticsearch methods', skip: true do
    it '.es_index_name' do
      expect(User.index_name).to eq 'users'
    end

    context '#as_indexed_json' do
      let!(:enterprise) do
        enterprise = create(:enterprise)
        enterprise.fields = [create(:field)]
        enterprise
      end

      let!(:user) do
        user = build(:user, enterprise: enterprise)
        user.info.merge(fields: user.enterprise.fields, form_data: { user.enterprise.fields.first.id => 'No' })
        user
      end

      let!(:poll) { create(:poll) }

      let!(:poll_response) do
        poll_response = build(:poll_response, user: user, poll: poll)
        poll_response.info.merge(fields: poll.fields, form_data: { poll.fields.first.id => 'Yes' })
        poll_response.save
        poll_response
      end

      let!(:user_group) { create(:user_group, user: user) }
      let!(:user_segment) { create(:users_segment, user: user) }

      it 'return data of user to be indexed by elasticsearch' do
        data = {
          "#{user.enterprise.fields.first.id}" => 'No',
          poll.fields.first.id => ['Yes'],
        }

        expect(user.as_indexed_json['combined_info']).to eq(data.merge(user.info_hash))
      end

      it 'rounds the created_at date to hour' do
        object = create(:user)

        expect(object.as_indexed_json['created_at']).to eq(object.created_at.beginning_of_hour)
      end
    end
  end

  describe '#group_leader_role' do
    it 'raises an User is not a group leader error' do
      user = create(:user)
      user.user_role = user.enterprise.user_roles.where(role_name: 'group_leader').first
      user.save

      expect(user.errors.full_messages.first).to eq('User role Cannot set user role to a group role')
    end
  end

  describe '#is_admin?' do
    it 'returns true' do
      user = create(:user)
      expect(user.is_admin?).to be(true)
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      user = create(:user)
      users_segment = create(:users_segment, user: user)
      user_group = create(:user_group, user: user, accepted_member: true)
      topic_feedback = create(:topic_feedback, user: user)
      # poll_response = create(:poll_response, :user => user)
      answer = create(:answer, author: user)
      answer_upvote = create(:answer_upvote, author_id: user.id)
      answer_comment = create(:answer_comment, author_id: user.id)
      campaign_invitation = create(:campaign_invitation, user: user)
      news_link = create(:news_link, author_id: user.id)
      group_message_comment = create(:group_message_comment, author_id: user.id)
      social_link = create(:social_link, author_id: user.id)
      initiative_user = create(:initiative_user, user: user)
      initiative_invitee = create(:initiative_invitee, user: user)
      # sample = create(:sample, :user => user)
      group_leader = create(:group_leader, user: user, group: user_group.group)
      user_reward_action = create(:user_reward_action, user: user)
      # reward = create(:reward, :responsible_id => user.id)

      policy_group = user.policy_group

      user.destroy

      expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { PolicyGroup.find(policy_group.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { UsersSegment.find(users_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { UserGroup.find(user_group.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { TopicFeedback.find(topic_feedback.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { UsersSegment.find(users_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      # expect{PollResponse.find(poll_response.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect { Answer.find(answer.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { AnswerUpvote.find(answer_upvote.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { AnswerComment.find(answer_comment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { CampaignInvitation.find(campaign_invitation.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { NewsLink.find(news_link.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { GroupMessageComment.find(group_message_comment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { SocialLink.find(social_link.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InitiativeUser.find(initiative_user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InitiativeInvitee.find(initiative_invitee.id) }.to raise_error(ActiveRecord::RecordNotFound)
      # expect{Sample.find(sample.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect { GroupLeader.find(group_leader.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { UserRewardAction.find(user_reward_action.id) }.to raise_error(ActiveRecord::RecordNotFound)
      # expect{Reward.find(reward.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'mentorship' do
    it 'goes through whole workflow' do
      # create a user interested in being mentored
      mentee = create(:user, mentee: true)

      # the mentorship doesn't have any mentors/mentees/availability/
      # mentorship_types/mentoring_interests
      expect(mentee.mentors.count).to eq(0)
      expect(mentee.mentees.count).to eq(0)
      expect(mentee.availabilities.count).to eq(0)
      expect(mentee.mentorship_types.count).to eq(0)
      expect(mentee.mentoring_interests.count).to eq(0)

      # the mentorship doesn't have any pending sessions/requests/ratings
      expect(mentee.mentorship_requests.count).to eq(0)
      expect(mentee.mentorship_proposals.count).to eq(0)
      expect(mentee.mentoring_sessions.count).to eq(0)
      expect(mentee.mentorship_ratings.count).to eq(0)

      # sending a request for mentorship to a mentor
      mentor = create(:user, mentor: true)
      mentorship_request = create(:mentoring_request, sender: mentee, receiver: mentor)

      # check the request
      expect(mentorship_request.valid?).to be(true)
      expect(mentorship_request.sender.id).to eq(mentee.id)
      expect(mentorship_request.receiver.id).to eq(mentor.id)

      expect(mentee.mentorship_requests.count).to eq(0)
      expect(mentee.mentorship_proposals.count).to eq(1)

      expect(mentor.mentorship_requests.count).to eq(1)
      expect(mentor.mentorship_proposals.count).to eq(0)

      # schedule a session
      mentoring_session = create(:mentoring_session, mentorship_sessions_attributes: [{ user_id: mentor.id, role: 'presenter' }, { user_id: mentee.id, role: 'attendee' }])

      # check the session
      expect(mentoring_session.valid?).to be(true)
      expect(mentoring_session.status).to eq('scheduled')
      expect(mentoring_session.users.count).to eq(2)

      # leave some ratings
      mentor_rating = build(:mentorship_rating, user: mentor, mentoring_session: mentoring_session)
      mentee_rating = build(:mentorship_rating, user: mentee, mentoring_session: mentoring_session)

      mentor_rating.comments = 'This is the best mentor ever'
      mentee_rating.comments = 'Mentee was a great listener'

      mentor_rating.save!
      mentee_rating.save!

      expect(mentor_rating.rating).to eq(7)
      expect(mentee_rating.rating).to eq(7)
    end
  end

  describe '#add_to_default_mentor_group' do
    it 'adds the user to the default_mentor_group then removes the user' do
      perform_enqueued_jobs do
        enterprise = create(:enterprise)
        user = create(:user, enterprise: enterprise)
        group = create(:group, enterprise: enterprise, default_mentor_group: true)

        expect(user.mentor).to be(false)
        expect(user.mentee).to be(false)
        expect(group.members.count).to eq(0)

        user.mentee = true
        user.save!

        expect(group.members.count).to eq(1)

        user.mentor = true
        user.save!

        expect(group.members.count).to eq(1)

        user.mentee = false
        user.save!

        expect(group.members.count).to eq(1)

        user.mentor = false
        user.save!

        expect(group.members.count).to eq(0)
      end
    end
  end
end

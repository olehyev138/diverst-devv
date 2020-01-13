require 'rails_helper'

RSpec.describe User do
  include ActiveJob::TestHelper
  it_behaves_like 'it Contains Field Data'

  describe 'when validating' do
    let(:user) { build(:user) }

    it { expect(user).to define_enum_for(:groups_notifications_frequency).with([:hourly, :daily, :weekly, :disabled]) }
    it { expect(user).to define_enum_for(:groups_notifications_date).with([:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]) }

    it 'validates password presence' do
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
    end

    context 'test' do
      context 'belongs_to associations' do
        # we dont validate presence of enterprise on user - TODO
        it { expect(user).to belong_to(:enterprise).without_validating_presence }
      end

      context 'has_many associations' do
        it { expect(user).to have_many(:users_segments) }
        it { expect(user).to have_many(:segments).through(:users_segments) }
        it { expect(user).to have_many(:groups).through(:user_groups) }
        it { expect(user).to have_many(:user_groups).dependent(:destroy) }
        it { expect(user).to have_many(:topic_feedbacks) }
        it { expect(user).to have_many(:poll_responses) }
        it { expect(user).to have_many(:answers).inverse_of(:author).with_foreign_key(:author_id) }
        it { expect(user).to have_many(:answer_upvotes).with_foreign_key(:author_id) }
        it { expect(user).to have_many(:answer_comments).with_foreign_key(:author_id) }
        it { expect(user).to have_many(:invitations).class_name('CampaignInvitation') }
        it { expect(user).to have_many(:campaigns).through(:invitations) }
        it { expect(user).to have_many(:news_links).through(:groups) }
        it { expect(user).to have_many(:own_news_links).class_name('NewsLink').with_foreign_key(:author_id) }
        it { expect(user).to have_many(:messages).through(:groups) }
        it { expect(user).to have_many(:message_comments).class_name('GroupMessageComment').with_foreign_key(:author_id) }
        it { expect(user).to have_many(:social_links).with_foreign_key(:author_id).dependent(:destroy) }
        it { expect(user).to have_many(:initiative_users) }
        it { expect(user).to have_many(:initiatives).through(:initiative_users).source(:initiative) }
        it { expect(user).to have_many(:initiative_invitees) }
        it { expect(user).to have_many(:invited_initiatives).through(:initiative_invitees).source(:initiative) }
        it { expect(user).to have_many(:managed_groups).with_foreign_key(:manager_id).class_name('Group') }
        it { expect(user).to have_many(:group_leaders) }
        it { expect(user).to have_many(:leading_groups).through(:group_leaders).source(:group) }
        it { expect(user).to have_many(:user_reward_actions) }
        it { expect(user).to have_many(:reward_actions).through(:user_reward_actions) }
        it { expect(user).to have_many(:metrics_dashboards).with_foreign_key(:owner_id) }
        it { expect(user).to have_many(:shared_metrics_dashboards) }
      end

      # ActiveStorage
      it { expect(user).to have_attached_file(:avatar) }
      it { expect(user).to validate_attachment_content_type(:avatar, AttachmentHelper.common_image_types) }
    end

    describe 'test callbacks' do
      let!(:new_enterprise) { create(:enterprise) }
      let!(:new_user) { build(:user, enterprise: new_enterprise) }

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
      end

      describe 'before_save callbacks' do
        #        context '#assign_firebase_token' do
        #          it 'should be called after user object is created' do
        #            new_user.run_callbacks :create
        #            expect(new_user.firebase_token.present?).to eq true
        #          end
        #        end
      end
    end

    describe 'before_destroy_callbacks' do
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

    context 'presence of fields' do
      let(:user) { build(:user, enterprise: enterprise) }
      let!(:mandatory_field) { build(:field, title: 'Test', required: true) }

      context 'with mandatory fields not filled' do
        let!(:enterprise) { create(:enterprise, fields: [mandatory_field]) }

        it 'should have an error on user' do
          user.info[mandatory_field] = ''
          user.valid?

          expect(user.errors.messages).to eq({ test: ["can't be blank"] })
        end
      end

      context 'with mandatory fields filled' do
        let!(:enterprise) { create(:enterprise, fields: [mandatory_field]) }

        it 'should be valid' do
          user.info[mandatory_field] = Faker::Lorem.paragraph(2)

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

  describe '#avatar_location' do
    it 'returns the actual avatar location' do
      user = create(:user, avatar: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })

      expect(user.avatar_location).to_not be nil
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

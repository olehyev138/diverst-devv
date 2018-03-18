require 'rails_helper'

RSpec.describe User do
  describe "when validating" do
    let(:user) { create(:user) }

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
        it { expect(user).to belong_to(:enterprise) }
        it { expect(user).to belong_to(:policy_group) }
      end

      context 'has_many associations' do
        it { expect(user).to have_many(:devices) }
        it { expect(user).to have_many(:users_segments) }
        it { expect(user).to have_many(:segments).through(:users_segments) }
        it { expect(user).to have_many(:groups).through(:user_groups) }
        it { expect(user).to have_many(:user_groups).dependent(:destroy) }
        it { expect(user).to have_many(:topic_feedbacks) }
        it { expect(user).to have_many(:poll_responses) }
        it { expect(user).to have_many(:answers).inverse_of(:author).with_foreign_key(:author_id) }
        it { expect(user).to have_many(:answer_upvotes).with_foreign_key(:author_id) }
        it { expect(user).to have_many(:answer_comments).with_foreign_key(:author_id)}
        it { expect(user).to have_many(:invitations).class_name('CampaignInvitation') }
        it { expect(user).to have_many(:campaigns).through(:invitations) }
        it { expect(user).to have_many(:news_links).through(:groups)}
        it { expect(user).to have_many(:own_news_links).class_name('NewsLink').with_foreign_key(:author_id) }
        it { expect(user).to have_many(:messages).through(:groups) }
        it { expect(user).to have_many(:message_comments).class_name('GroupMessageComment').with_foreign_key(:author_id) }
        it { expect(user).to have_many(:events).through(:groups) }
        it { expect(user).to have_many(:social_links).with_foreign_key(:author_id).dependent(:destroy) }
        it { expect(user).to have_many(:initiative_users) }
        it { expect(user).to have_many(:initiatives).through(:initiative_users).source(:initiative) }
        it { expect(user).to have_many(:initiative_invitees) }
        it { expect(user).to have_many(:invited_initiatives).through(:initiative_invitees).source(:initiative) }
        it { expect(user).to have_many(:event_attendances) }
        it { expect(user).to have_many(:attending_events).through(:event_attendances).source(:event) }
        it { expect(user).to have_many(:event_invitees) }
        it { expect(user).to have_many(:invited_events).through(:event_invitees).source(:event) }
        it { expect(user).to have_many(:managed_groups).with_foreign_key(:manager_id).class_name('Group') }
        it { expect(user).to have_many(:samples) }
        it { expect(user).to have_many(:biases).class_name('Bias') }
        it { expect(user).to have_many(:group_leaders) }
        it { expect(user).to have_many(:leading_groups).through(:group_leaders).source(:group) }
        it { expect(user).to have_many(:user_reward_actions) }
        it { expect(user).to have_many(:reward_actions).through(:user_reward_actions) }
      end

      context 'validate paperclip' do
        it { expect(user).to have_attached_file(:avatar) }
        it { expect(user).to validate_attachment_content_type(:avatar).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml' ) }
      end
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
        context '#assign_policy_group' do 
          it 'should be called before user object is created' do 
            expect(new_user).to receive(:assign_policy_group)
            new_user.save
          end
        end

        context '#assign_firebase_token' do 
          it 'should be called after user object is created' do
            new_user.run_callbacks :create
            expect(new_user.firebase_token.present?).to eq true
          end
        end
      end
    end


    context 'presence of fields' do
      let(:user){ build(:user, enterprise: enterprise) }
      let!(:mandatory_field){ create(:field, title: "Test", required: true) }

      context 'with mandatory fields not filled' do
        let!(:enterprise){ create(:enterprise, fields: [mandatory_field]) }

        it "should have an error on user" do
          user.info[mandatory_field] = ""
          user.valid?

          expect(user.errors.messages).to eq({ test: ["can't be blank"] })
        end
      end

      context 'with mandatory fields filled' do
        let!(:enterprise){ create(:enterprise, fields: [mandatory_field]) }

        it "should be valid" do
          user.info[mandatory_field] = Faker::Lorem.paragraph(2)

          expect(user).to be_valid
        end
      end
    end
  end

  describe 'when describing callbacks' do
    let!(:user){ create(:user) }

    it "should index user on elasticsearch after create" do
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

    it "should reindex user on elasticsearch after update" do
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

    it "should remove user from elasticsearch after destroy" do
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
      it 'only returnes active users' do
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
  end

  describe '#erg_leader?' do
    let!(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }

    subject { user.erg_leader? }

    context 'when user is a leader of an erg' do
      before  do
        group.members << user
        group.group_leaders << GroupLeader.new(group: group, user: user, position_name: 'blah')
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
    let(:user){ build_stubbed(:user, points: 100) }
    let(:badge_one){ create(:badge, points: 100) }
    let(:badge_two){ create(:badge, points: 101) }

    it 'returns the badges based on how much points a user has' do
      expect(user.badges).to eq [badge_one]
    end
  end

  describe '#active_group_member?' do
    let!(:enterprise) { create(:enterprise)}
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

  describe "#name" do
    let(:user){ build_stubbed(:user, first_name: "John", last_name: "Doe") }

    it "return the full name of user" do
      expect(user.name).to eq "John Doe"
    end
  end

  describe "#name_with_status" do
    context "of an active user" do
      let(:user){ build_stubbed(:user, first_name: "John", last_name: "Doe", active: true) }

      it "return the full name of user" do
        expect(user.name_with_status).to eq "John Doe"
      end
    end

    context "of an inactive user" do
      let(:user){ build_stubbed(:user, first_name: "John", last_name: "Doe", active: false) }

      it "return the full name of user with status" do
        expect(user.name_with_status).to eq "John Doe (inactive)"
      end
    end
  end

  describe 'policy group' do
    let!(:enterprise) { create :enterprise}

    context 'when creating user' do
      context 'with policy group' do
        let!(:policy_group) { create :policy_group, enterprise: enterprise, default_for_enterprise: true }
        let(:other_policy_group)  { create :policy_group, enterprise: enterprise, default_for_enterprise: false }

        let!(:user) { build :user, enterprise: enterprise, policy_group: other_policy_group }

        before { user.save! }

        it 'keeps policy group' do
          expect(user.reload.policy_group).to eq other_policy_group
        end

        it 'changes policy group users count' do
          expect(other_policy_group.reload.users).to include(user)
        end
      end

      context 'without policy group' do
        let!(:policy_group) { create :policy_group, enterprise: enterprise }

        let!(:user) { build :user, enterprise: enterprise, policy_group: nil }

        before { user.save! }

        it 'sets policy group to default in enterprise' do
          expect(user.reload.policy_group).to eq policy_group
        end

        it 'changes policy group users count' do
          expect(policy_group.reload.users).to include(user)
        end
      end
    end
  end

  describe 'group surveys' do
    let(:user) { create(:user) }
    let(:group) { create(:group, enterprise: user.enterprise) }
    let(:sample_data) { '{\"96\":\"save me 2\",\"98\":\"I am borisano and this is survey\",\"100\":[\"two\"],\"101\":[\"one\",\"two\"],\"102\":40,\"103\":null}' }
    let!(:user_group) { create :user_group, user: user, group: group, data: sample_data }

    describe '#has_answered_group_surveys?' do
      subject { user.has_answered_group_surveys? }

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
      subject { user.has_answered_group_survey? group }

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

  describe 'elasticsearch methods' do
    it '.es_index_name' do
      enterprise = build_stubbed(:enterprise)
      expect(User.es_index_name(enterprise: enterprise)).to eq "#{ enterprise.id }_users"
    end

    context '#as_indexed_json' do
      let!(:enterprise) do
        enterprise = create(:enterprise)
        enterprise.fields = [create(:field)]
        enterprise
      end

      let!(:user) do
        user = build(:user, enterprise: enterprise)
        user.info.merge(fields: user.enterprise.fields, form_data: { user.enterprise.fields.first.id => "No" })
        user
      end

      let!(:poll) { create(:poll, fields: [create(:field)]) }

      let!(:poll_response) do
        poll_response = build(:poll_response, user: user, poll: poll)
        poll_response.info.merge(fields: poll.fields, form_data: { poll.fields.first.id => "Yes" })
        poll_response.save
        poll_response
      end

      let!(:user_group) { create(:user_group, user: user) }
      let!(:user_segment) { create(:users_segment, user: user) }

      it 'return data of user to be indexed by elasticsearch' do
        data = {
          "#{ user.enterprise.fields.first.id }" => "No",
          poll.fields.first.id => "Yes",
          groups: [user_group.group_id],
          segments: [user_segment.segment_id]
        }

        expect(user.as_indexed_json['combined_info']).to eq(data)
      end
    end
  end
end

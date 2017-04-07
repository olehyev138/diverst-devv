require 'rails_helper'

RSpec.describe User do
  describe "when validating" do
    let(:user) { create(:user) }

    it { expect(user).to have_many(:user_reward_actions) }
    it { expect(user).to have_many(:reward_actions).through(:user_reward_actions) }
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

  describe '#participation_score' do
    subject { create(:user) }
    let(:user) { create(:user) }
    let(:campaigns) { create_list(:campaign_filled, 2) }

    it 'returns 5 points per poll response' do
      polls = create_list(:poll_with_responses, 5)

      polls.each do |poll|
        poll.responses << create(:poll_response, user: user)
        poll.save
      end

      expect(user.participation_score(from: 0)).to eq 25
    end

    it 'returns 5 points per scrum answer and 1 point per answer upvote received' do
      campaigns.each do |campaign|
        campaign.questions.each do |question|
          answer = build(:answer, author: user, question: question)
          answer.votes << create_list(:answer_upvote, 2, user: user)
          answer.save
        end

        campaign.save
      end

      expect(user.participation_score(from: 0)).to eq 28
    end

    it 'returns 3 points per scrum comment' do
      campaigns.each do |campaign|
        campaign.questions.each do |question|
          question.answers.each do |answer|
            answer.comments << create(:answer_comment, author: user)
            answer.save
          end

          question.save
        end

        campaign.save
      end

      expect(user.participation_score(from: 0)).to eq 24
    end

    it 'returns 1 point per scrum upvote given' do
      create_list(:answer_upvote, 10, user: user)

      expect(user.participation_score(from: 0)).to eq 10
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

  describe 'when validating' do
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
    # describe 'saml password behaviour' do
    #   let(:user) { build :user, enterprise: ent, password: '', password_confirmation: '' }

    #   context 'with saml enabled' do
    #     let(:ent) { create :enterprise, has_enabled_saml: true }

    #     it 'do not require password' do
    #       expect(user).to be_valid
    #     end
    #   end

    #   context 'with saml disabled' do
    #     let(:ent) { create :enterprise, has_enabled_saml: false }

    #     it 'requires password' do
    #       expect(user).to be_invalid
    #     end

    #     it 'requires password confirmation to be equal to password' do
    #       user.password = 'randompassword'

    #       expect(user).to be_invalid
    #     end
    #   end
    # end

    # describe 'first name' do
    #   let(:user) { build :user, first_name: '' }

    #   it 'is invalid without first name' do
    #     expect(user).to_not be_valid
    #   end
    # end

    # describe 'last name' do
    #   let(:user) { build :user, last_name: '' }

    #   it 'is invalid without last name' do
    #     expect(user).to_not be_valid
    #   end
    # end
  end

  it { is_expected.to have_attached_file(:avatar) }

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
end

require 'rails_helper'

RSpec.describe User do
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
    let!(:group) { create(:group, enterprise: enterprise) }

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

  it { is_expected.to have_attached_file(:avatar) }
end

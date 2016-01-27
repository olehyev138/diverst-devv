require 'rails_helper'

RSpec.describe Employee do
  describe '#participation_score' do
    subject { create(:employee) }
    let(:employee) { create(:employee) }
    let(:campaigns) { create_list(:campaign_filled, 2) }

    it 'returns 5 points per poll response' do
      polls = create_list(:poll_with_responses, 5)

      polls.each do |poll|
        poll.responses << create(:poll_response, employee: employee)
        poll.save
      end

      expect(employee.participation_score(from: 0)).to eq 25
    end

    it 'returns 5 points per scrum answer and 1 point per answer upvote received' do
      campaigns.each do |campaign|
        campaign.questions.each do |question|
          answer = build(:answer, author: employee, question: question)
          answer.votes << create_list(:answer_upvote, 2, employee: employee)
          answer.save
        end

        campaign.save
      end

      expect(employee.participation_score(from: 0)).to eq 28
    end

    it 'returns 3 points per scrum comment' do
      campaigns.each do |campaign|
        campaign.questions.each do |question|
          question.answers.each do |answer|
            answer.comments << create(:answer_comment, author: employee)
            answer.save
          end

          question.save
        end

        campaign.save
      end

      expect(employee.participation_score(from: 0)).to eq 24
    end

    it 'returns 1 point per scrum upvote given' do
      create_list(:answer_upvote, 10, employee: employee)

      expect(employee.participation_score(from: 0)).to eq 10
    end
  end

  it { is_expected.to have_attached_file(:avatar) }
end

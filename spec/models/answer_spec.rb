require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'when validating' do
    let(:answer) { build(:answer) }

    describe 'test associations and validations' do
      it { expect(answer).to belong_to(:question).inverse_of(:answers).counter_cache(true) }
      it { expect(answer).to belong_to(:author).class_name('User').inverse_of(:answers) }
      it { expect(answer).to belong_to(:contributing_group).class_name('Group') }
      it { expect(answer).to have_many(:votes).class_name('AnswerUpvote').dependent(:destroy) }
      it { expect(answer).to have_many(:voters).through(:votes).class_name('User').source(:user) }
      it { expect(answer).to have_many(:comments).class_name('AnswerComment').dependent(:destroy) }
      it { expect(answer).to have_many(:expenses).class_name('AnswerExpense').dependent(:destroy) }
      it { expect(answer).to have_many(:user_reward_actions) }
      it { expect(answer).to have_many(:likes).dependent(:destroy) }
      it { expect(answer).to accept_nested_attributes_for(:expenses).allow_destroy(true) }

      # it { expect(answer).to have_attached_file(:supporting_document) }
      it { expect(answer).to validate_presence_of(:question) }
      it { expect(answer).to validate_presence_of(:author) }
      it { expect(answer).to validate_presence_of(:content) }
      it { expect(answer).to validate_presence_of(:contributing_group) }
      it { expect(answer).to validate_length_of(:outcome).is_at_most(65535) }
      it { expect(answer).to validate_length_of(:content).is_at_most(65535) }
    end
  end

  describe '#total_likes' do
    it 'returns 10' do
      answer = create :answer
      create_list(:like, 10, answer: answer)
      expect(answer.total_likes).to eq(10)
    end
  end

  describe '#total_value' do
    it 'returns 0' do
      answer = create :answer
      expect(answer.total_value).to eq(0)
    end

    it 'returns 100' do
      answer = create :answer
      answer.value = 100
      expect(answer.total_value).to eq(100)
    end

    it 'returns 500' do
      answer = create :answer, value: 100
      expense = create :expense, income: true, price: 10
      create_list :answer_expense, 4, answer: answer, expense: expense, quantity: 10
      expect(answer.total_value).to eq(500)
    end
  end

  #  describe '#supporting_document_extension' do
  #    it "returns '' " do
  #      answer = create :answer
  #      expect(answer.supporting_document_extension).to eq('')
  #    end
  #  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      answer = create(:answer)
      answer_upvote = create(:answer_upvote, answer: answer)
      answer_comment = create(:answer_comment, answer: answer)
      answer_expense = create(:answer_expense, answer: answer)

      answer.destroy

      expect { Answer.find(answer.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { AnswerUpvote.find(answer_upvote.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { AnswerComment.find(answer_comment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { AnswerExpense.find(answer_expense.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

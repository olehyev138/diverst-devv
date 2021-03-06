require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'when validating' do
    let(:answer) { build_stubbed(:answer) }

    describe 'test associations and validations' do
      it { expect(answer).to belong_to(:question).inverse_of(:answers) }
      it { expect(answer).to belong_to(:author).class_name('User').inverse_of(:answers) }
      it { expect(answer).to belong_to(:idea_category) }
      it { expect(answer).to belong_to(:contributing_group).class_name('Group') }
      it { expect(answer).to have_many(:votes).class_name('AnswerUpvote') }
      it { expect(answer).to have_many(:voters).through(:votes).class_name('User').source(:user) }
      it { expect(answer).to have_many(:comments).class_name('AnswerComment') }
      it { expect(answer).to have_many(:expenses).class_name('AnswerExpense') }
      it { expect(answer).to accept_nested_attributes_for(:expenses).allow_destroy(true) }

      it { expect(answer).to have_attached_file(:supporting_document) }
      it { expect(answer).to validate_attachment_content_type(:supporting_document).allowing('text/plain', 'application/pdf') }
      it { expect(answer).to have_attached_file(:video_upload) }
      it { expect(answer).to validate_attachment_content_type(:video_upload).allowing('video/mp4', 'video/webm') }
      it { expect(answer).to have_attached_file(:supporting_document_from_sponsor) }
      it { expect(answer).to validate_attachment_content_type(:supporting_document_from_sponsor).allowing('text/plain', 'application/pdf') }
      it { expect(answer).to validate_presence_of(:question) }
      it { expect(answer).to validate_presence_of(:author) }
      it { expect(answer).to validate_presence_of(:content) }
      it { expect(answer).to validate_presence_of(:title) }
      it { expect(answer).to validate_presence_of(:idea_category) }
    end
  end

  describe '#total_value' do
    it 'returns 0' do
      answer = create(:answer, title: 'Idea', idea_category: create(:idea_category))
      expect(answer.total_value).to eq(0)
    end

    it 'returns 100' do
      answer = create(:answer, title: 'Idea', idea_category: create(:idea_category))
      answer.value = 100
      expect(answer.total_value).to eq(100)
    end

    it 'returns 500' do
      answer = create :answer, value: 100, title: 'Idea', idea_category: create(:idea_category)
      expense = create :expense, income: true, price: 10
      create_list :answer_expense, 4, answer: answer, expense: expense, quantity: 10
      expect(answer.total_value).to eq(500)
    end
  end

  describe '#supporting_document_extension' do
    it "returns '' " do
      answer = create(:answer, title: 'Idea', idea_category: create(:idea_category))
      expect(answer.supporting_document_extension).to eq('')
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      answer = create(:answer, title: 'Idea', idea_category: create(:idea_category))
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

  describe '#after_create_callback' do
    it 'sends email notification' do 
      answer = build(:answer, title: 'Idea', idea_category: create(:idea_category))
      expect(answer).to receive(:send_email_notification)
      answer.save
    end 
  end
end

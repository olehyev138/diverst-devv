require 'rails_helper'

RSpec.describe AnswerComment, type: :model do
  describe 'when validating' do
    let(:answer_comment) { build_stubbed(:answer_comment) }

    it { expect(answer_comment).to belong_to(:author) }
    it { expect(answer_comment).to belong_to(:answer) }
    it { expect(answer_comment).to validate_presence_of(:author) }
    it { expect(answer_comment).to validate_presence_of(:answer) }
    it { expect(answer_comment).to validate_presence_of(:content) }
  end
  
  describe ".unapproved" do
    it "returns the answer_comments that have not been approved" do
      create_list(:answer_comment, 2, :approved => false)
      expect(AnswerComment.unapproved.count).to eq(2)
    end
  end
end

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
end

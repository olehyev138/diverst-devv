require 'rails_helper'

RSpec.describe AnswerExpense, type: :model do
  describe 'when validating' do
    let(:answer_expense) { build_stubbed(:answer_expense) }

    it { expect(answer_expense).to belong_to(:answer) }
    it { expect(answer_expense).to belong_to(:expense) }
    it { expect(answer_expense).to validate_presence_of(:answer) }
    it { expect(answer_expense).to validate_presence_of(:expense) }
  end
end

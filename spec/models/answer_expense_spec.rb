require 'rails_helper'

RSpec.describe AnswerExpense, type: :model do
  describe 'when validating' do
    let(:answer_expense) { build_stubbed(:answer_expense) }
    
    it { expect(answer_expense).to belong_to(:answer) }
    it { expect(answer_expense).to belong_to(:expense) }
  end
end

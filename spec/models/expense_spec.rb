require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'validations' do
    let(:expense) { build_stubbed(:expense) }

    it { expect(expense).to validate_presence_of(:name) }
    it { expect(expense).to validate_presence_of(:enterprise) }
    it { expect(expense).to validate_presence_of(:category) }
    it { expect(expense).to validate_presence_of(:price) }
    it { expect(expense).to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { expect(expense).to validate_length_of(:name).is_at_most(191) }

    it { expect(expense).to belong_to(:enterprise) }
    it { expect(expense).to belong_to(:category).class_name('ExpenseCategory') }

    it { expect(expense).to have_many(:answer_expenses).dependent(:destroy) }
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      expense = create(:expense)
      answer_expense = create(:answer_expense, expense: expense)

      expense.destroy!

      expect { Expense.find(expense.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { AnswerExpense.find(answer_expense.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#signed_price' do
    it 'returns postive price when income is true' do
      expense = create(:expense, income: true)
      expect(expense.signed_price).to be > 0
    end

    it 'returns negative price when income is false' do
      expense = create(:expense, income: false)
      expect(expense.signed_price).to be < 0
    end
  end
end

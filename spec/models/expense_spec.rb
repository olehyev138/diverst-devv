require 'rails_helper'

RSpec.describe Expense, type: :model do

    describe 'validations' do
        let(:expense) { FactoryGirl.build_stubbed(:expense) }

        it{ expect(expense).to validate_presence_of(:name) }
        it{ expect(expense).to validate_presence_of(:enterprise) }
        it{ expect(expense).to validate_presence_of(:category) }
        it { expect(expense).to validate_presence_of(:price) }
        it { expect(expense).to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

        it { expect(expense).to belong_to(:enterprise) }
        it { expect(expense).to belong_to(:category).class_name('ExpenseCategory') }

        it { expect(expense).to have_many(:answer_expenses) }
    end
end

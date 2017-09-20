require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'when validating' do
    let(:expense) { build_stubbed(:expense) }

    it { expect(expense).to belong_to(:enterprise) }
    it { expect(expense).to belong_to(:category) }
    it { expect(expense).to have_many(:answer_expenses) }
    it { expect(expense).to validate_presence_of(:enterprise) }
    it { expect(expense).to validate_presence_of(:category) }
    it { expect(expense).to validate_presence_of(:name) }
    it { expect(expense).to validate_presence_of(:price) }
    it { expect(expense).to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end
end

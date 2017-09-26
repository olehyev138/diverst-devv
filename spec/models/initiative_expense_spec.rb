require 'rails_helper'

RSpec.describe InitiativeExpense, type: :model do
  describe 'when validating' do
    let(:initiative_expense) { build_stubbed(:initiative_expense) }

    it { expect(initiative_expense).to belong_to(:initiative) }
    it { expect(initiative_expense).to belong_to(:owner).class_name("User") }
    it { expect(initiative_expense).to validate_presence_of(:initiative) }
    it { expect(initiative_expense).to validate_presence_of(:owner) }
    it { expect(initiative_expense).to validate_presence_of(:amount) }
    it { expect(initiative_expense).to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  end
end

require 'rails_helper'

RSpec.describe Expense, type: :model do
    
    describe 'validations' do
        let(:expense_category) { FactoryGirl.build_stubbed(:expense_category) }

        it{ expect(expense_category).to validate_presence_of(:name) }
        it{ expect(expense_category).to validate_presence_of(:enterprise) }
        
        it { expect(expense_category).to belong_to(:enterprise) }

        it { expect(expense_category).to have_many(:expenses) }
    end
end

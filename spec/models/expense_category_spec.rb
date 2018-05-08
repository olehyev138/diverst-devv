require 'rails_helper'

RSpec.describe ExpenseCategory, type: :model do
    
    describe 'validations' do
        let(:expense_category) { FactoryGirl.build_stubbed(:expense_category) }

        it{ expect(expense_category).to validate_presence_of(:name) }
        it{ expect(expense_category).to validate_presence_of(:enterprise) }
        
        it { expect(expense_category).to belong_to(:enterprise) }

        it { expect(expense_category).to have_many(:expenses) }
    end
    
    describe "#destroy_callbacks" do
        it "removes the child objects" do
            expense_category = create(:expense_category)
            expense = create(:expense, :category => expense_category)
            
            expense_category.destroy!
            
            expect{ExpenseCategory.find(expense_category.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Expense.find(expense.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
    end
end

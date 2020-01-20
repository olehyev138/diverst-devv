require 'rails_helper'

RSpec.describe ExpenseCategory, type: :model do
  describe 'validations' do
    let(:expense_category) { build(:expense_category) }

    it { expect(expense_category).to validate_presence_of(:name) }
    it { expect(expense_category).to validate_presence_of(:enterprise) }

    it { expect(expense_category).to belong_to(:enterprise) }

    it { expect(expense_category).to have_many(:expenses).dependent(:destroy).with_foreign_key(:category_id) }

    # ActiveStorage
    it { expect(expense_category).to have_attached_file(:icon) }
    it { expect(expense_category).to validate_attachment_content_type(:icon, AttachmentHelper.common_image_types) }
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      expense_category = create(:expense_category)
      expense = create(:expense, category: expense_category)

      expense_category.destroy!

      expect { ExpenseCategory.find(expense_category.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Expense.find(expense.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

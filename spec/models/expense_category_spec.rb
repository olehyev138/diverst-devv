require 'rails_helper'

RSpec.describe Expense, type: :model do

    describe 'validations' do
        let(:expense_category) { FactoryGirl.build_stubbed(:expense_category) }

        it{ expect(expense_category).to validate_presence_of(:name) }
        it{ expect(expense_category).to validate_presence_of(:enterprise) }

        it { expect(expense_category).to belong_to(:enterprise) }

        it { expect(expense_category).to have_many(:expenses).dependent(:destroy).with_foreign_key(:category_id) }

        it { expect(expense_category).to have_attached_file(:icon) }
        it { expect(expense_category).to validate_attachment_content_type(:icon).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml') }
    end
end

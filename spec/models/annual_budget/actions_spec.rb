require 'rails_helper'

RSpec.describe AnnualBudget::Actions, type: :model do
  describe 'ClassMethods' do
    describe 'order_string' do
      it { expect(AnnualBudget.order_string('name', 'asc')).to eq 'annual_budgets.closed asc, name asc' }
    end
  end
end

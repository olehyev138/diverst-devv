require 'rails_helper'

RSpec.describe BudgetItem::Actions, type: :model do
  describe 'valid_scopes' do
    it { expect(BudgetItem.valid_scopes.include?('approved')).to eq true }
  end

  describe 'base_includes' do
    it { expect(BudgetItem.base_includes.include?(:budget)).to eq true }
  end

  describe 'close' do
    let(:item_without_id) { build :budget_item, id: nil }
    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }

    it 'has no id' do
      expect { item_without_id.close(Request.create_request(user)) }.to raise_error(BadRequestException)
    end

    it 'is already closed' do
      item = create(:budget_item, is_done: true)
      expect { item.close(Request.create_request(user)) }.to raise_error(InvalidInputException)
    end

    it 'is still using' do
      item = create(:budget_item, is_done: true)
      create(:initiative, budget_item_id: item.id)
      expect { item.close(Request.create_request(user)) }.to raise_error(InvalidInputException)
    end

    it 'is successfully closed' do
      item = create(:budget_item, is_done: false)
      expect(item.close(Request.create_request(user)).is_done).to be true
    end
  end
end

require 'rails_helper'

RSpec.describe BudgetItem::Actions, type: :model do
  describe 'valid_scopes' do
    let(:valid_scopes) { ['approved'] }

    it { expect(BudgetItem.valid_scopes).to eq valid_scopes }
  end

  describe 'base_includes' do
    let(:base_includes) { [:budget] }

    it { expect(BudgetItem.base_includes).to eq base_includes }
  end

  describe 'close' do
    let(:item_without_id) { build :budget_item, id: nil }
    let(:enterprise) { create(:enterprise) }
    let(:user) { create(:user, enterprise: enterprise) }

    it 'raises an exception if id is missing' do
      expect { item_without_id.close(Request.create_request(user)) }.to raise_error(BadRequestException)
    end

    it 'raises an exception if budget is already closed' do
      item = create(:budget_item, is_done: true)
      expect { item.close(Request.create_request(user)) }.to raise_error(InvalidInputException)
    end

    it 'raises an exception if budget is still using' do
      item = create(:budget_item, is_done: true)
      create(:initiative, budget_item_id: item.id)
      expect { item.close(Request.create_request(user)) }.to raise_error(InvalidInputException)
    end

    it 'closes successfully' do
      item = create(:budget_item, is_done: false)
      expect(item.close(Request.create_request(user)).is_done).to be true
    end
  end
end

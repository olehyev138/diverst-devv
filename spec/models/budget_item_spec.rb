require 'rails_helper'

RSpec.describe BudgetItem, type: :model do
  describe 'when validating' do
    let(:budget_item) { build(:budget_item) }

    it { expect(budget_item).to belong_to(:budget).counter_cache(:true) }
    it { expect(budget_item).to have_one(:annual_budget).through(:budget) }
    it { expect(budget_item).to have_one(:group).through(:annual_budget) }

    it { expect(budget_item).to have_many(:initiatives) }
    it { expect(budget_item).to have_many(:initiatives_expenses).through(:initiatives).source(:expenses) }

    it { expect(budget_item).to validate_presence_of(:title) }
    it { expect(budget_item).to validate_length_of(:title).is_at_least(2) }
    it { expect(budget_item).to validate_length_of(:title).is_at_most(191) }
    it { expect(budget_item).to validate_presence_of(:budget) }
    it { expect(budget_item).to validate_numericality_of(:estimated_amount).is_less_than_or_equal_to(999999).with_message('number of digits must not exceed 6') }
  end

  describe 'test scopes' do
    context 'budget_item::allocated' do
      let!(:allocated_budget_item) { create(:budget_item, is_done: true) }

      it 'returns budget item allocated' do
        expect(BudgetItem.allocated).to eq([allocated_budget_item])
      end
    end

    context 'budget_item::available' do
      let!(:budget) { create(:approved_budget) }

      it 'returns budget item available' do
        expect(BudgetItem.available.count).to eq 3
      end
    end

    context 'budget_item::approved' do
      let!(:budget) { create(:approved_budget) }

      it 'returns budget item approved' do
        expect(BudgetItem.approved.count).to eq 3
      end
    end

    context 'budget_item::not_approved' do
      let!(:budget) { create(:budget, is_approved: false) }

      it 'returns budget item not approved' do
        expect(BudgetItem.not_approved.count).to eq 3
      end
    end

    context 'budget_item::pending' do
      let!(:budget) { create(:budget) }

      it 'returns budget item pending' do
        expect(BudgetItem.pending.count).to eq 3
      end
    end

    context 'budget_item::private_scope' do
      let!(:budget) { create(:budget, requester_id: nil) }

      it 'returns budget item private scope' do
        expect(BudgetItem.private_scope.count).to eq 3
      end
    end
  end

  describe '#close!' do
    context 'budget item is closed' do
      let(:budget_item) { create(:budget_item, is_done: true) }
      it 'prevents budget closing' do
        budget_item.close!
        expect(budget_item.errors.size).to_not be 0
        expect(budget_item.errors.full_messages).to include 'Budget Item is already closed'
      end
    end

    context 'budget item having an active event' do
      let!(:group) { create(:group) }
      let!(:budget) { create(:budget, is_approved: true, group: group) }
      let!(:budget_item) { create(:budget_item, budget: budget, estimated_amount: 200) }
      let!(:initiative) { create(:initiative, budget_item: budget_item, estimated_funding: 100, pillar: group.outcomes.first.pillars.first) }
      it 'prevents budget closing' do
        budget_item.close!
        expect(budget_item.errors.size).to_not be 0
        expect(budget_item.errors.full_messages).to include 'There are still events using this budget item'
      end
    end

    context 'budget item having no active event' do
      let!(:group) { create(:group) }
      let!(:budget) { create(
          :budget,
          is_approved: true,
          group: group,
          budget_items: [build(:budget_item, estimated_amount: 200)]
      )}
      let!(:budget_item) { budget.budget_items.first }
      let!(:initiative) { create(
          :initiative,
          budget_item: budget_item,
          estimated_funding: 100,
          pillar: group.outcomes.first.pillars.first,
          start: 10.days.ago,
          end: 5.days.ago,
      )}
      let!(:initiatives_expenses) { create(:initiative_expense, initiative: initiative, amount: 50) }
      it 'allows closing and refunds approved budget' do
        ab = budget_item.annual_budget
        expect(ab.reload.approved).to eq 200
        expect(initiative.finish_expenses!).to be true
        budget_item.close!
        expect(budget_item.errors.size).to be 0
        expect(ab.reload.approved).to eq 50
      end
    end
  end
end

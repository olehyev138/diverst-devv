require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe 'factory' do
    let(:budget) { FactoryGirl.build(:budget) }
    let(:approved_budget) { FactoryGirl.build :approved_budget }

    it 'is valid' do
      expect(budget).to be_valid
      expect(approved_budget).to be_valid
    end
  end

  describe 'amounts' do
    let!(:budget) { FactoryGirl.create :approved_budget }
    let(:requested_amount) { budget.budget_items.sum(:estimated_amount) }

    before { budget.budget_items.first.update(is_done: true) }

    describe '#requested_amount' do
      it 'sums all budget items' do
        expect(budget.requested_amount).to eq requested_amount
      end
    end

    describe '#available_amount' do
      context 'with approved budget' do
        it 'sums only active budget items' do
          active_available = requested_amount - budget.budget_items.first.estimated_amount

          expect(budget.available_amount).to eq active_available
        end
      end

      context 'with not approved budget' do
        let!(:budget) { FactoryGirl.create :budget }

        it 'always return 0' do
          expect(budget.available_amount).to eq 0
        end
      end
    end
  end

  describe '#approve!' do
    let(:budget) { FactoryGirl.build :budget }

    before { budget.approve! }

    it 'changes is_approved to true' do
      expect(budget.is_approved).to eq true
    end
  end

  describe '#decline!' do
    let(:budget) { FactoryGirl.build :approved_budget }

    before { budget.decline! }

    it 'changes is_approved to true' do
      expect(budget.is_approved).to eq false
    end
  end

  describe 'self.' do
    describe 'pre_approved_events' do
      let(:group) { FactoryGirl.create :group }
      let!(:budget) { FactoryGirl.create :budget, subject: group }
      let!(:approved_budget) { FactoryGirl.create :approved_budget, subject: group }

      subject { described_class.pre_approved_events(group) }

      it 'contain items only from approved budgets' do
        expect(subject).to include approved_budget.budget_items.first
        expect(subject).to_not include budget.budget_items.first
      end

      it 'contain only items that are not done yet' do
        approved_budget.budget_items.first.update(is_done: true)

        expect(subject).to_not include approved_budget.budget_items.first
      end

      it 'contain Leftover item'
    end

    describe 'pre_approved_events_for_select' do
      xit 'implement me'
    end
  end
end

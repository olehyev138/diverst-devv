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

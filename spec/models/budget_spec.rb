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
    end

    describe 'pre_approved_events_for_select' do
    end
  end
end

require 'rails_helper'

RSpec.describe InitiativeDecorator do
  let(:initiative) { create :initiative }

  describe '#progress_percentage' do
    it 'returns nil' do
      initiative.start = nil
      decorated_initiative = initiative.decorate
      expect(decorated_initiative.progress_percentage).to eq(nil)
    end

    it 'returns 100' do
      initiative.end = Date.yesterday
      decorated_initiative = initiative.decorate
      expect(decorated_initiative.progress_percentage).to eq(100)
    end

    it 'returns 50' do
      initiative.start = 7.days.ago
      initiative.end = Date.today + 7.days
      decorated_initiative = initiative.decorate
      expect(decorated_initiative.progress_percentage).to be > 45
    end
  end

  describe '#budget_percentage' do
    it 'returns 0' do
      initiative.estimated_funding = 0
      decorated_initiative = initiative.decorate
      expect(decorated_initiative.budget_percentage).to eq(0)
    end

    it 'returns 0' do
      initiative.estimated_funding = 1000
      decorated_initiative = initiative.decorate
      expect(decorated_initiative.budget_percentage).to eq(0)
    end

    it 'returns 50' do
      initiative.group.update(annual_budget: 10000)
      create(:annual_budget, amount: initiative.group.annual_budget)
      initiative.estimated_funding = 1000
      # create expenses
      4.times do
        initiative.expenses.create!(amount: 125, owner: initiative.owner)
      end
      decorated_initiative = initiative.decorate
      expect(decorated_initiative.budget_percentage).to eq(50.0)
    end
  end
end

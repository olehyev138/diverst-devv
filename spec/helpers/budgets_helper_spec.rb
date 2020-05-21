require 'rails_helper'

RSpec.describe BudgetsHelper do
  let!(:budget1) { create(:budget, approver_id: create(:user).id) }
  let!(:budget2) { create(:budget, requester_id: create(:user).id) }

  describe '#requester_name' do
    it "returns requester's name when present" do
      expect(requester_name(budget2)).to eq budget2.requester.name
    end

    it "returns 'Unknown' when requester is absent" do
      budget2.update(requester_id: nil)
      expect(requester_name(budget2)).to eq 'Unknown'
    end
  end

  describe '#approver_name' do
    it "returns approver's name when present" do
      expect(approver_name(budget1)).to eq budget1.approver.name
    end

    it 'returns Unknown when approver is absent' do
      budget1.update(approver_id: nil)
      expect(approver_name(budget1)).to eq 'Unknown'
    end
  end
end

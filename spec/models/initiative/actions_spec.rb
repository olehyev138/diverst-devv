require 'rails_helper'

RSpec.describe Initiative::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :pillar,
          :owner,
          :outcome,
          :group,
          :participating_groups,
          :qr_code_attachment, :qr_code_blob,
          :initiative_users
      ]
    }

    it { expect(Initiative.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end

  describe 'valid_scopes' do
    let(:valid_scopes) {
      %w(
          upcoming
          ongoing
          past
          not_archived
          archived
          of_annual_budget
          joined_events_for_user
          available_events_for_user
          for_groups
          for_segments
          date_range
      )
    }

    it { expect(Initiative.valid_scopes).to eq valid_scopes }
  end

  describe 'generate_qr_code' do
    it 'generates qr_code' do
      item = create(:initiative)
      Initiative.generate_qr_code(Request.create_request(create(:user)), { id: item.id })
      expect(item.qr_code).to_not be nil
    end
  end

  describe 'finalize_expenses' do
    it 'raises an exception if id is missing' do
      item = build(:initiative, id: nil)
      expect { item.finalize_expenses(Request.create_request(create(:user))) }.to raise_error(BadRequestException)
    end

    it 'raises an exception if expense is finished' do
      item = create(:initiative, finished_expenses: true)
      expect { item.finalize_expenses(Request.create_request(create(:user))) }.to raise_error(InvalidInputException)
    end

    it 'finalizes expense' do
      item = create(:initiative, finished_expenses: false)
      expect(item.finalize_expenses(Request.create_request(create(:user))).finished_expenses).to eq true
    end
  end
end

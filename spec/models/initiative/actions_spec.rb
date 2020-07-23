require 'rails_helper'

RSpec.describe Initiative::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(Initiative.base_preloads.include?(:pillar)).to eq true }
    it { expect(Initiative.base_preloads.include?(:owner)).to eq true }
    it { expect(Initiative.base_preloads.include?(:budget)).to eq true }
    it { expect(Initiative.base_preloads.include?(:outcome)).to eq true }
    it { expect(Initiative.base_preloads.include?(:group)).to eq true }
    it { expect(Initiative.base_preloads.include?(:expenses)).to eq true }
    it { expect(Initiative.base_preloads.include?(:picture_attachment)).to eq true }
    it { expect(Initiative.base_preloads.include?(:qr_code_attachment)).to eq true }
    it { expect(Initiative.base_preloads.include?(:initiative_users)).to eq true }
    it { expect(Initiative.base_preloads.include?(:comments)).to eq true }
  end

  describe 'valid_scopes' do
    it { expect(Initiative.valid_scopes.include?('upcoming')).to eq true }
    it { expect(Initiative.valid_scopes.include?('ongoing')).to eq true }
    it { expect(Initiative.valid_scopes.include?('past')).to eq true }
    it { expect(Initiative.valid_scopes.include?('not_archived')).to eq true }
    it { expect(Initiative.valid_scopes.include?('archived')).to eq true }
    it { expect(Initiative.valid_scopes.include?('of_annual_budget')).to eq true }
    it { expect(Initiative.valid_scopes.include?('joined_events_for_user')).to eq true }
    it { expect(Initiative.valid_scopes.include?('available_events_for_user')).to eq true }
    it { expect(Initiative.valid_scopes.include?('for_groups')).to eq true }
    it { expect(Initiative.valid_scopes.include?('for_segments')).to eq true }
    it { expect(Initiative.valid_scopes.include?('date_range')).to eq true }
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

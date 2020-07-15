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
end

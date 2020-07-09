require 'rails_helper'

RSpec.describe Activity::Actions, type: :action do
  describe 'valid_scopes' do
    it { expect(Activity.valid_scopes.include?('joined_from')).to eq true }
    it { expect(Activity.valid_scopes.include?('joined_to')).to eq true }
    it { expect(Activity.valid_scopes.include?('for_group_ids')).to eq true }
  end

  describe 'base_preloads' do
    it { expect(Activity.base_preloads.include?(:owner)).to eq true }
  end
end

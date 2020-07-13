require 'rails_helper'

RSpec.describe Enterprise::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(Enterprise.base_preloads.include?(:theme)).to eq true }
  end
end

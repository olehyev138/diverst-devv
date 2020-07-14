require 'rails_helper'

RSpec.describe GroupMessage::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(GroupMessage.base_preloads.include?(:owner)).to eq true }
    it { expect(GroupMessage.base_preloads.include?(:group)).to eq true }
    it { expect(GroupMessage.base_preloads.include?(:comments)).to eq true }
  end
end

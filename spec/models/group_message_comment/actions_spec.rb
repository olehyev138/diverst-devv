require 'rails_helper'

RSpec.describe GroupMessageComment::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(GroupMessageComment.base_preloads.include?(:author)).to eq true }
  end
end

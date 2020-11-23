require 'rails_helper'

RSpec.describe Enterprise::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) { [:theme, :custom_text, :sponsors, :mentoring_interests, :mentoring_types] }

    it { expect(Enterprise.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end

  # Todo
  describe 'sso login' do
  end

  # Todo
  describe 'sso link' do
  end
end

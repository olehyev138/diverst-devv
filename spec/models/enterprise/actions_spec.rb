require 'rails_helper'

RSpec.describe Enterprise::Actions, type: :model do
  describe 'base_preloads' do
    let!(:base_preloads) { [:theme] }
    it { expect(Enterprise.base_preloads).to eq base_preloads }
  end

  # Todo
  describe 'sso login' do
  end

  # Todo
  describe 'sso link' do
  end
end

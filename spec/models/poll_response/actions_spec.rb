require 'rails_helper'

RSpec.describe PollResponse::Actions, type: :model do
  describe 'base_preloads' do
    let!(:base_preloads) { [:poll, :user, :field_data, field_data: [:field, { field: [:field_definer] }]] }
    it { expect(PollResponse.base_preloads).to eq base_preloads }
  end
end

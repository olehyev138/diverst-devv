require 'rails_helper'

RSpec.describe PollResponse::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(PollResponse.base_preloads.include?(:poll)).to eq true }
    it { expect(PollResponse.base_preloads.include?(:user)).to eq true }
    it { expect(PollResponse.base_preloads.include?(:field_data)).to eq true }
    it { expect(PollResponse.base_preloads.include?({ field_data: [:field, { field: [:field_definer] }] })).to eq true }
  end
end

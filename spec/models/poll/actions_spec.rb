require 'rails_helper'

RSpec.describe Poll::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :fields,
          :poll_responses,
          :groups,
          :segments,
      ]
    }

    it { expect(Poll.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end

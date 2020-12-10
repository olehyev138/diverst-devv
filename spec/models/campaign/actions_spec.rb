require 'rails_helper'

RSpec.describe Campaign::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :image_attachment, :image_blob,
          :banner_attachment, :banner_blob,
          :groups,
      ]
    }

    it { expect(Campaign.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end

require 'rails_helper'

RSpec.describe Campaign::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :image_attachment,
          :banner_attachment,
          :groups,
          groups: [
              :logo_attachment,
              :user_groups,
              :group_leaders,
              :news_feed,
              :banner_attachment,
              {}
          ]
      ]
    }

    it { expect(Campaign.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end

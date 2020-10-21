require 'rails_helper'

RSpec.describe Campaign::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :image_attachment, :image_blob,
          :banner_attachment, :banner_blob,
          :groups,
          groups: [
              :logo_attachment, :logo_blob,
              :user_groups,
              :group_leaders,
              :news_feed,
              :banner_attachment, :banner_blob,
              {
                  children: [:logo_attachment,
                             :logo_blob,
                             :user_groups,
                             :group_leaders,
                             :news_feed,
                             :banner_attachment,
                             :banner_blob],
                  parent: [:logo_attachment,
                           :logo_blob,
                           :user_groups,
                           :group_leaders,
                           :news_feed,
                           :banner_attachment,
                           :banner_blob]
              }
          ]
      ]
    }

    it { expect(Campaign.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end

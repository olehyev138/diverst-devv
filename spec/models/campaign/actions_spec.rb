require 'rails_helper'

RSpec.describe Campaign::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :questions,
          :image_attachment,
          :banner_attachment,
          :groups,
          groups: [
              :news_feed,
              :annual_budgets,
              :logo_attachment,
              :banner_attachment,
              { enterprise: [:theme] },
              :user_groups,
              :group_leaders,
              :children,
              :parent,
              :enterprise,
              children: [
                  :news_feed,
                  :annual_budgets,
                  :logo_attachment,
                  :banner_attachment,
                  { enterprise: [:theme] },
                  :user_groups,
                  :group_leaders,
                  :children,
                  :parent,
                  :enterprise
              ],
              parent: [
                  :news_feed,
                  :annual_budgets,
                  :logo_attachment,
                  :banner_attachment,
                  { enterprise: [:theme] },
                  :user_groups,
                  :group_leaders,
                  :children,
                  :parent,
                  :enterprise
              ]
          ]
      ]
    }

    it { expect(Campaign.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end

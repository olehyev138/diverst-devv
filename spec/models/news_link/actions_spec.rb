require 'rails_helper'

RSpec.describe NewsLink::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :author,
          :group,
          :comments,
          :photos,
          :picture_attachment,
          author: [
              :field_data,
              :enterprise,
              :user_groups,
              :user_role,
              :news_links,
              :avatar_attachment,
              :avatar_blob,
              enterprise: [
                  :theme,
                  :mobile_fields
              ],
              field_data: [
                  :field,
                  field: [:field_definer]
              ]
          ],
          comments: [
              :author,
              author: [:field_data,
                       :enterprise,
                       :user_groups,
                       :user_role,
                       :news_links,
                       :avatar_attachment,
                       :avatar_blob,
                       enterprise: [
                           :theme,
                           :mobile_fields
                       ],
                       field_data: [
                           :field,
                           field: [:field_definer]
                       ]
              ]
          ],
          group: [:enterprise]
      ]
    }

    it { expect(NewsLink.base_preloads).to eq base_preloads }
  end
end

require 'rails_helper'

RSpec.describe GroupMessage::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :owner,
          :group,
          :comments,
          comments: [:author,
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
          group: [:enterprise],
          owner: [
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
          ]
      ]
    }

    it { expect(GroupMessage.base_preloads).to eq base_preloads }
  end
end

require 'rails_helper'

RSpec.describe NewsFeedLink::Actions, type: :model do
  describe 'valid_scopes' do
    let(:valid_scopes) {
      %w(
          approved
          pending
          combined_news_links
          not_archived
          archived
          pinned
          not_pinned
      )
    }

    it { expect(NewsFeedLink.valid_scopes).to eq valid_scopes }
  end

  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :group_message,
          :news_link,
          :social_link,
          :news_feed,
          :views,
          :likes,
          group_message: [:owner,
                          :group,
                          :comments,
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
          ],
          news_link: [
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
                  ]
              ],
              group: [:enterprise]
          ],
          social_link: [
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
          ]
      ]
    }

    it { expect(NewsFeedLink.base_preloads).to eq base_preloads }
  end

  describe 'base_left_joins' do
    let(:base_left_joins) {
      [
          :group_message,
          :news_link,
          :social_link
      ]
    }

    it { expect(NewsFeedLink.base_left_joins).to eq base_left_joins }
  end

  describe 'order_string' do
    it { expect(NewsFeedLink.order_string('id', 'asc')).to eq 'news_feed_links.is_pinned desc, id asc' }
  end
end

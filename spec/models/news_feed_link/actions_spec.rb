require 'rails_helper'

RSpec.describe NewsFeedLink::Actions, type: :model do
  describe 'valid_scopes' do
    it { expect(NewsFeedLink.valid_scopes.include?('approved')).to eq true }
    it { expect(NewsFeedLink.valid_scopes.include?('pending')).to eq true }
    it { expect(NewsFeedLink.valid_scopes.include?('combined_news_links')).to eq true }
    it { expect(NewsFeedLink.valid_scopes.include?('not_archived')).to eq true }
    it { expect(NewsFeedLink.valid_scopes.include?('archived')).to eq true }
    it { expect(NewsFeedLink.valid_scopes.include?('pinned')).to eq true }
    it { expect(NewsFeedLink.valid_scopes.include?('not_pinned')).to eq true }
  end

  describe 'base_preloads' do
    it { expect(NewsFeedLink.base_preloads.include?(:group_message)).to eq true }
    it { expect(NewsFeedLink.base_preloads.include?(:news_link)).to eq true }
    it { expect(NewsFeedLink.base_preloads.include?(:social_link)).to eq true }
    it { expect(NewsFeedLink.base_preloads.include?(:news_feed)).to eq true }
    it { expect(NewsFeedLink.base_preloads.include?(:views)).to eq true }
    it { expect(NewsFeedLink.base_preloads.include?(:likes)).to eq true }
    it { expect(NewsFeedLink.base_preloads.include?(group_message: [:owner,
                                                                    :group,
                                                                    :comments,
                                                                    { comments: [:author,
                                                                                 { author: [:field_data,
                                                                                            :enterprise,
                                                                                            :user_groups,
                                                                                            :user_role,
                                                                                            :news_links,
                                                                                            :avatar_attachment,
                                                                                            :avatar_blob,
                                                                                            { enterprise: [:theme, :mobile_fields],
                                                                                              field_data: [:field, { field: [:field_definer] }] }] }],
                                                                      group: [:enterprise],
                                                                      owner: [:field_data,
                                                                              :enterprise,
                                                                              :user_groups,
                                                                              :user_role,
                                                                              :news_links,
                                                                              :avatar_attachment,
                                                                              :avatar_blob,
                                                                              { enterprise: [:theme, :mobile_fields],
                                                                                field_data: [:field, { field: [:field_definer] }] }] }],
                                                    news_link: [:author,
                                                                :group,
                                                                :comments,
                                                                :photos,
                                                                :picture_attachment,
                                                                { author: [:field_data,
                                                                           :enterprise,
                                                                           :user_groups,
                                                                           :user_role,
                                                                           :news_links,
                                                                           :avatar_attachment,
                                                                           :avatar_blob,
                                                                           { enterprise: [:theme, :mobile_fields],
                                                                             field_data: [:field, { field: [:field_definer] }] }],
                                                                  comments: [:author,
                                                                             { author: [:field_data,
                                                                                        :enterprise,
                                                                                        :user_groups,
                                                                                        :user_role,
                                                                                        :news_links,
                                                                                        :avatar_attachment,
                                                                                        :avatar_blob,
                                                                                        { enterprise: [:theme, :mobile_fields],
                                                                                          field_data: [:field, { field: [:field_definer] }] }] }],
                                                                  group: [:enterprise] }],
                                                    social_link: [:author,
                                                                  { author: [:field_data,
                                                                             :enterprise,
                                                                             :user_groups,
                                                                             :user_role,
                                                                             :news_links,
                                                                             :avatar_attachment,
                                                                             :avatar_blob,
                                                                             { enterprise: [:theme, :mobile_fields],
                                                                               field_data: [:field, { field: [:field_definer] }] }] }])).to eq true
    }
  end

  describe 'base_left_joins' do
    it { expect(NewsFeedLink.base_left_joins.include?(:group_message)).to eq true }
    it { expect(NewsFeedLink.base_left_joins.include?(:news_link)).to eq true }
    it { expect(NewsFeedLink.base_left_joins.include?(:social_link)).to eq true }
  end

  describe 'order_string' do
    it { expect(NewsFeedLink.order_string('id', 'asc')).to eq 'news_feed_links.is_pinned desc, id asc' }
  end
end
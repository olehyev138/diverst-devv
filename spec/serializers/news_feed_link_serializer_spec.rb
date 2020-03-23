require 'rails_helper'

RSpec.describe NewsFeedLinkSerializer, type: :serializer do
  it 'returns news_link and correct views/likes count' do
    news_feed_link = create(:news_feed_link, group_message: nil, social_link: nil)
    create(:news_feed_link)

    news_feed_link.reload

    serializer = NewsFeedLinkSerializer.new(news_feed_link, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:news_feed]).to_not be_nil
    expect(serializer.serializable_hash[:news_link]).to_not be_nil
    expect(serializer.serializable_hash[:group_message]).to be_nil
    expect(serializer.serializable_hash[:social_link]).to be_nil
    expect(serializer.serializable_hash[:total_views]).to eq 0
    expect(serializer.serializable_hash[:total_likes]).to eq 0
  end

  it 'returns group_message and correct views/likes count' do
    group_message = create(:group_message)
    news_feed_link = create(:news_feed_link, news_link: nil, group_message: group_message, social_link: nil)
    create_list(:like, 5, news_feed_link_id: news_feed_link.id)
    create_list(:view, 5, news_feed_link_id: news_feed_link.id)

    news_feed_link.reload

    serializer = NewsFeedLinkSerializer.new(news_feed_link, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:news_feed]).to_not be_nil
    expect(serializer.serializable_hash[:news_link]).to be_nil
    expect(serializer.serializable_hash[:group_message]).to_not be_nil
    expect(serializer.serializable_hash[:social_link]).to be_nil
    expect(serializer.serializable_hash[:total_views]).to eq 5
    expect(serializer.serializable_hash[:total_likes]).to eq 5
  end

  it 'returns social_link and correct views/likes count' do
    social_link = create(:social_link)
    news_feed_link = create(:news_feed_link, news_link: nil, group_message: nil, social_link: social_link)
    create_list(:like, 10, news_feed_link_id: news_feed_link.id)
    create_list(:view, 10, news_feed_link_id: news_feed_link.id)

    news_feed_link.reload

    serializer = NewsFeedLinkSerializer.new(news_feed_link, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:news_feed]).to_not be_nil
    expect(serializer.serializable_hash[:news_link]).to be_nil
    expect(serializer.serializable_hash[:group_message]).to be_nil
    expect(serializer.serializable_hash[:social_link]).to_not be_nil
    expect(serializer.serializable_hash[:total_views]).to eq 10
    expect(serializer.serializable_hash[:total_likes]).to eq 10
  end
end

require 'rails_helper'

migration_file_name = Dir[Rails.root.join('db/migrate/20190227050001_removed_all_orphaned_posts.rb')].first
require migration_file_name

RSpec.describe RemovedAllOrphanedPosts, type: :migration do
  let(:migration) { RemovedAllOrphanedPosts.new }
  let!(:news_links) { create_list(:news_link, 2) }
  let!(:social_links) { create_list(:social_link, 2) }
  let!(:group_messages) { create_list(:group_message, 2) }

  describe '#change' do
    # this creates orphaned posts by calling delete which bypasses any callbacks that may have been called on destruction.
    it 'remove orhpaned posts' do
      SocialLink.reset_column_information
      NewsLink.reset_column_information
      GroupMessage.reset_column_information

      expect(NewsLink.includes(:news_feed_link)).to_not be_empty
      expect(SocialLink.includes(:news_feed_link)).to_not be_empty
      expect(GroupMessage.includes(:news_feed_link)).to_not be_empty
      expect(NewsFeedLink.count).to eq 6


      NewsFeedLink.where(news_link_id: [news_links.map(&:id)]).delete_all
      NewsFeedLink.where(group_message_id: [group_messages.map(&:id)]).delete_all
      NewsFeedLink.where(social_link_id: [social_links.map(&:id)]).delete_all
      migration.migrate(:up)

      SocialLink.reset_column_information
      NewsLink.reset_column_information
      GroupMessage.reset_column_information

      expect(NewsLink.includes(:news_feed_link)).to be_empty
      expect(SocialLink.includes(:news_feed_link)).to be_empty
      expect(GroupMessage.includes(:news_feed_link)).to be_empty
      expect(NewsFeedLink.count).to eq 0
    end
  end
end

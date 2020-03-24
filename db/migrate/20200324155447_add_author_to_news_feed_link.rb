class AddAuthorToNewsFeedLink < ActiveRecord::Migration[5.2]
  def change
    add_reference :news_feed_links, :user, foreign_key: :author_id, index: true

    NewsFeedLink.column_reload!
    NewsFeedLink.find_each do |nfl|
      nfl.update(author_id:
          nfl.group_message&.owner_id ||
          nfl.news_link&.author_id ||
          nfl.social_link&.author_id
      )
    end
  end
end

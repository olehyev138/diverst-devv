class AddNewsLinkCommentsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :news_link_comments_count, :integer
  end
end

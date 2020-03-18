class AddNewsLinkCommentsCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :news_link_comments_count, :integer
  end
end

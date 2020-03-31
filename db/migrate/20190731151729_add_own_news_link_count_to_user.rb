class AddOwnNewsLinkCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :own_news_links_count, :integer
  end
end

class AddOwnNewsLinkCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :own_news_links_count, :integer
  end
end

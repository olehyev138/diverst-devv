class ChangeStringToText < ActiveRecord::Migration
  def change
    change_column :news_links, :description, :text
  end
end

class ChangeStringToText < ActiveRecord::Migration[5.1]
  def change
    change_column :news_links, :description, :text
  end
end

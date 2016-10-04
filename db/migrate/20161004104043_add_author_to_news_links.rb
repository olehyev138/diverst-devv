class AddAuthorToNewsLinks < ActiveRecord::Migration
  def change
    change_table :news_links do |t|
      t.integer :author_id
    end
  end
end

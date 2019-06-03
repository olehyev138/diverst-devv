class AddAuthorToNewsLinks < ActiveRecord::Migration[5.1]
  def change
    change_table :news_links do |t|
      t.integer :author_id
    end
  end
end

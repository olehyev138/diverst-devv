class CreateNewsCommentsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :news_link_comments do |t|
      t.text :content
      t.belongs_to :author
      t.belongs_to :news_link

      t.timestamps null: false
    end
  end
end
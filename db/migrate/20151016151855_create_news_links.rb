class CreateNewsLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :news_links do |t|
      t.string :title
      t.string :description
      t.string :url

      t.belongs_to :group

      t.timestamps null: false
    end
  end
end

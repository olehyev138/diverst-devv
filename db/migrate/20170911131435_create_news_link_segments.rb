class CreateNewsLinkSegments < ActiveRecord::Migration[5.1]
  def change
    create_table :news_link_segments do |t|
      t.references    :news_link
      t.references    :segment
      t.timestamps    null: false
    end
  end
end

class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :sponsor_name
      t.string :sponsor_title
      t.text :sponsor_message
      t.boolean :disable_sponsor_message
      t.references :sponsorable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end

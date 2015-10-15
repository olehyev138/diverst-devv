class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start
      t.datetime :end
      t.string :location
      t.integer :max_attendees

      t.belongs_to :group

      t.timestamps null: false
    end
  end
end

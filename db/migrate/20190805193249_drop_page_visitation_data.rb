class DropPageVisitationData < ActiveRecord::Migration
  def change
    drop_table :page_visitation_data do |t|
      t.integer :user_id
      t.string :page
      t.integer :times_visited
      t.integer :time_on_page

      t.timestamps null: false
    end
  end
end

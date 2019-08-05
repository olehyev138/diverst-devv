class CreatePageVisitations < ActiveRecord::Migration
  def change
    create_table :page_visitations do |t|
      t.belongs_to :user

      t.string :page_name
      t.string :page_site
      t.string :controller
      t.string :action

      t.integer :visits_day, default: 0
      t.integer :visits_week, default: 0
      t.integer :visits_month, default: 0
      t.integer :visits_year, default: 0
      t.integer :visits_all, default: 0

      t.timestamps null: false
    end
  end
end

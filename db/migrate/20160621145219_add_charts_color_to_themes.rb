class AddChartsColorToThemes < ActiveRecord::Migration
  def change
    change_table :themes do |t|
      t.string :secondary_color
    end
  end
end

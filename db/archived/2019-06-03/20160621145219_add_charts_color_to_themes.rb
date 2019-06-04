class AddChartsColorToThemes < ActiveRecord::Migration[5.1]
  def change
    change_table :themes do |t|
      t.string :secondary_color
    end
  end
end

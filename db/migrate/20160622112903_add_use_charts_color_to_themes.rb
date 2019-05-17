class AddUseChartsColorToThemes < ActiveRecord::Migration[5.1]
  def change
    change_table :themes do |t|
      t.boolean :use_secondary_color, default: false
    end
  end
end

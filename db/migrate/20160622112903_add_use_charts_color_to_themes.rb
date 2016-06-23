class AddUseChartsColorToThemes < ActiveRecord::Migration
  def change
    change_table :themes do |t|
      t.boolean :use_secondary_color, default: false
    end
  end
end

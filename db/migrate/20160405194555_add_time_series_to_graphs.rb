class AddTimeSeriesToGraphs < ActiveRecord::Migration[5.1]
  def change
    change_table :graphs do |t|
      t.boolean :time_series, default: false
    end
  end
end

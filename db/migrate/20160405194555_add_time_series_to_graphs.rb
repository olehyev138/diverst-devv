class AddTimeSeriesToGraphs < ActiveRecord::Migration
  def change
    change_table :graphs do |t|
      t.boolean :time_series, default: false
    end
  end
end

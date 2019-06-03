class AddDateRangesToGraphs < ActiveRecord::Migration[5.1]
  def change
    change_table :graphs do |t|
      t.datetime :range_from
      t.datetime :range_to
    end
  end
end

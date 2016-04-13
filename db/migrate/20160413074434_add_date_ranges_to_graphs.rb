class AddDateRangesToGraphs < ActiveRecord::Migration
  def change
    change_table :graphs do |t|
      t.datetime :range_from
      t.datetime :range_to
    end
  end
end

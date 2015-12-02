class ConvertGraphsToPolymorphic < ActiveRecord::Migration
  def change
    change_table :graphs do |t|
      t.belongs_to :collection, polymorphic: true, index: true
      t.remove :metrics_dashboard_id
    end
  end
end

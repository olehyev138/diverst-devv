class ConvertGraphsToPolymorphic < ActiveRecord::Migration[5.1]
  def change
    change_table :graphs do |t|
      t.belongs_to :collection, polymorphic: true, index: true
      t.remove :metrics_dashboard_id
    end
  end
end

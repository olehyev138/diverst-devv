class AddSystemFieldToFields < ActiveRecord::Migration
  def change
    change_table :fields do |t|
      t.boolean :elasticsearch_only, default: false
    end
  end
end

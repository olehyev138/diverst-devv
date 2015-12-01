class AddPrivateToFields < ActiveRecord::Migration
  def change
    change_table :fields do |t|
      t.boolean :private, default: false
    end
  end
end

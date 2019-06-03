class AddPrivateToFields < ActiveRecord::Migration[5.1]
  def change
    change_table :fields do |t|
      t.boolean :private, default: false
    end
  end
end

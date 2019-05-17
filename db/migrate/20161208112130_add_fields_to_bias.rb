class AddFieldsToBias < ActiveRecord::Migration[5.1]
  def change
    change_table :biases do |t|
      t.boolean :sexual_harassment,   default: false
      t.boolean :inequality,          default: false
    end
  end
end

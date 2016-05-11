class AddTextFieldToBiases < ActiveRecord::Migration
  def change
    change_table :biases do |t|
      t.text :description
    end
  end
end

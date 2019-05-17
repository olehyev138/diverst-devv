class AddTextFieldToBiases < ActiveRecord::Migration[5.1]
  def change
    change_table :biases do |t|
      t.text :description
    end
  end
end

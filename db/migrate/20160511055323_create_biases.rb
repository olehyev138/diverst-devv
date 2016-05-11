class CreateBiases < ActiveRecord::Migration
  def change
    create_table :biases do |t|
      t.belongs_to :user
      t.text :from_data
      t.text :to_data
      t.boolean :anonymous
      t.integer :severity

      t.timestamps
    end

    create_table :biases_from_groups do |t|
      t.belongs_to :group
      t.belongs_to :bias
    end

    create_table :biases_to_groups do |t|
      t.belongs_to :group
      t.belongs_to :bias
    end
  end
end

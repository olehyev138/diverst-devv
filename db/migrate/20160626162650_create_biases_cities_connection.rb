class CreateBiasesCitiesConnection < ActiveRecord::Migration[5.1]
  def change
    create_table :biases_from_cities do |t|
      t.integer :bias_id
      t.integer :city_id
    end

    create_table :biases_to_cities do |t|
      t.integer :bias_id
      t.integer :city_id
    end
  end
end

class DropBiasesAndBiasesRelatedTables < ActiveRecord::Migration
  def change
  	drop_table :biases 
  	drop_table :biases_from_cities
  	drop_table :biases_from_departments
  	drop_table :biases_from_groups
  	drop_table :biases_to_cities
  	drop_table :biases_to_departments
  	drop_table :biases_to_groups
  end
end

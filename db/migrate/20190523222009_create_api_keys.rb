class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.string :application_name
      t.string :key
      t.references :enterprise

      t.timestamps
    end
  end
end

class CreateAhoyEvents < ActiveRecord::Migration
  def change
    create_table :ahoy_events do |t|
      t.references :visit
      t.references :user

      t.string :name
      t.json :properties
      t.timestamp :time
    end

    # add_column :ahoy_events, :properties, :json

    add_index :ahoy_events, [:name, :time]
  end
end

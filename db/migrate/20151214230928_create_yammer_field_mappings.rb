class CreateYammerFieldMappings < ActiveRecord::Migration
  def change
    create_table :yammer_field_mappings do |t|
      t.belongs_to :enterprise
      t.string :yammer_field_name
      t.belongs_to :diverst_field

      t.timestamps null: false
    end
  end
end

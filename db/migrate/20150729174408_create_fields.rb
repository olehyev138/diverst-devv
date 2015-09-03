class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :type
      t.string :title
      t.integer :gamification_value, default: 1
      t.boolean :show_on_vcard
      t.string :saml_attribute
      t.text :options_text

      t.integer :min
      t.integer :max

      # Algo settings
      t.boolean :match_exclude # Defines wether or not a field will be used in the match algo
      t.boolean :match_polarity # Defines if the fields will be matched the closer they are or the further they are
      t.float :match_weight # Defines the field's weight in the matching algo

      t.belongs_to :enterprise

      t.timestamps null: false
    end
  end
end

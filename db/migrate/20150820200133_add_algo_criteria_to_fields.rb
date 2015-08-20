class AddAlgoCriteriaToFields < ActiveRecord::Migration
  def change
    change_table :fields do |t|
      t.boolean :match_exclude # Defines wether or not a field will be used in the match algo
      t.boolean :match_polarity # Defines if the fields will be matched the closer they are or the further they are
      t.float :match_weight # Defines the field's weight in the matching algo
    end
  end
end

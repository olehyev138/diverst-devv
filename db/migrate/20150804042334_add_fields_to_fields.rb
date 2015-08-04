class AddFieldsToFields < ActiveRecord::Migration
  def change
    change_table(:fields) do |t|
      t.integer :gamification_value
      t.boolean :show_on_vcard
    end
  end
end

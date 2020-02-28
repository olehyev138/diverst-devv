class AddCustomFlagToEmails < ActiveRecord::Migration[5.2]
  def change
    change_table :emails do |t|
      t.boolean :custom, default: false
    end
  end
end

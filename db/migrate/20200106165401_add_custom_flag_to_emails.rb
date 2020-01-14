class AddCustomFlagToEmails < ActiveRecord::Migration
  def change
    change_table :emails do |t|
      t.boolean :custom, default: false
    end
  end
end
class AddUserToCsvFileModel < ActiveRecord::Migration
  def change
    change_table :csvfiles do |t|
      t.integer :user_id, null: false
    end
  end
end

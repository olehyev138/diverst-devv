class AddFirebaseTokenToEmployees < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.string :firebase_token
    end
  end
end

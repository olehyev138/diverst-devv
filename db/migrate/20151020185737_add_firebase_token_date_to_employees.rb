class AddFirebaseTokenDateToEmployees < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.datetime :firebase_token_generated_at
    end
  end
end

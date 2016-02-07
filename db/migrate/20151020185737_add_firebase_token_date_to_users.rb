class AddFirebaseTokenDateToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.datetime :firebase_token_generated_at
    end
  end
end

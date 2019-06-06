class AddFirebaseTokenDateToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.datetime :firebase_token_generated_at
    end
  end
end

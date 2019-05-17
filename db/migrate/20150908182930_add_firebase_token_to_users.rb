class AddFirebaseTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.string :firebase_token
    end
  end
end

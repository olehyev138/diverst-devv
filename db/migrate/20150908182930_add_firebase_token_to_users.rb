class AddFirebaseTokenToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :firebase_token
    end
  end
end

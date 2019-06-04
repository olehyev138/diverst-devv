class AddYammerTokenToUser < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.string :yammer_token
    end
  end
end

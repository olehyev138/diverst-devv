class AddYammerTokenToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :yammer_token
    end
  end
end

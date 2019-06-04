class AddYammerTokenToEnterprise < ActiveRecord::Migration[5.1]
  def change
    change_table :enterprises do |t|
      t.string :yammer_token
    end
  end
end
